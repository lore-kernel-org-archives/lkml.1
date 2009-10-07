Return-Path: <linux-kernel-owner+w=401wt.eu-S934186AbZJGIlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbZJGIlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934178AbZJGIlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:41:49 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:50067 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934135AbZJGIls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:41:48 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 4/7] printk: remove redundant test
Date: Wed,  7 Oct 2009 09:39:44 +0100
Message-Id: <1254904787-11323-5-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_token() cannot change the value of p.  So there is no need to test
*p again after calling print_token().

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 kernel/printk.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 69f717a..1714435 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -772,9 +772,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 
 			/* Always output the token */
 			printk_token(current_log_level);
-
-			if (!*p)
-				break;
 		}
 
 		emit_log_char(*p);
-- 
1.6.3.2

