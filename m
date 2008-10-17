Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYJQNRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYJQNRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYJQNQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:16:50 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:27928 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbYJQNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fvRhQ08H8e1PEQjyFa2/wZGpXLKPuc8dU09+Ju/obXT9GlCDDb+BHHwSLTmXeS5WU+
         Oj0bLAFoQIO2kEHZulYJDyMSoeqNdfdORV2IvJEH4rejWBopjRz6QTtMIeBI2BjyOI2d
         Pd8xJue3TF3+6kWDwZylaRSTrYpgHhP36kfms=
From: Jike Song <albcamus@gmail.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Jike Song <albcamus@gmail.com>
Subject: [PATCH] x86: add missed clobber for 32-bit memmove
Date: Fri, 17 Oct 2008 21:15:53 +0800
Message-Id: <1224249353-3032-2-git-send-email-albcamus@gmail.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1224249353-3032-1-git-send-email-albcamus@gmail.com>
References: <1224249353-3032-1-git-send-email-albcamus@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memmove() is implemented by inline assembly. It calls std at first
and cld at last, but EFLAGS still should be clobbered.

Signed-off-by: Jike Song <albcamus@gmail.com>
---
 arch/x86/lib/memcpy_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 5415a9d..99a8240 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -36,7 +36,7 @@ void *memmove(void *dest, const void *src, size_t n)
 			:"0" (n),
 			 "1" (n-1+src),
 			 "2" (n-1+dest)
-			:"memory");
+			:"cc", "memory");
 	}
 	return dest;
 }
-- 
1.6.0.1

