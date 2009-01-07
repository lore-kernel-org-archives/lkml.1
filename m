Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZAGJ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZAGJ3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZAGJ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:29:22 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:44335 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZAGJ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:29:20 -0500
Subject: [PATCH] [TRIVIAL] linux/types.h: Don't depend on __GNUC__ for
	__le64 / __be64 [synced to git]
From: Detlef Riekenberg <wine.dev@web.de>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, trivial@kernel.org
In-Reply-To: <1231029623.7225.10.camel@p4.lan>
References: <1230594921.7652.35.camel@p4.lan>
	 <1231029623.7225.10.camel@p4.lan>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 10:29:18 +0100
Message-Id: <1231320558.5547.21.camel@p4.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ZdWUEcrv8nnaHc2T5o/qc3E9FFkIM/lLs95ix
	guJUkRyeyDTIB29WLCfxZnmHW28XvLnqew/kcC4zcOt1UhZ9ui
	8Oo+WMNfI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
<linux/cdrom.h> is used in Wine, but failed to compile with pcc.
(__le64 and __be64 are referenced in <linux/byteorder/little_endian.h>)

There is no reason to restrict the typedefs to __GNUC__.
This Patch is trivial for gcc and icc, but required for other compiler.

As reference, the typedefs for __u64 and __s64 where fixed to be
available for other compiler on 02. Mai 2008 by H. Peter Anvin
(commit edfa5cfa3dc5bfa95e6aa82a2b8904e7f6c35ed7)

Wine: http://www.winehq.org
pcc:  http://pcc.ludd.ltu.se

This patch is again a resync to current git.
Is there anything, that I can do for this Patch?

Please CC me personally. Thanks

-- 
Bye bye ... Detlef



>From ce469182d86b94e4e2fd4c84028369a2eefdfb0c Mon Sep 17 00:00:00 2001
From: Detlef Riekenberg <wine.dev@web.de>
Date: Wed, 7 Jan 2009 10:11:44 +0100
Subject: [PATCH] linux/types.h: Don't depend on __GNUC__ for
__le64/__be64

Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Detlef Riekenberg <wine.dev@web.de>
---
 include/linux/types.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 3b864f2..712ca53 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -176,10 +176,9 @@ typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
 typedef __u32 __bitwise __le32;
 typedef __u32 __bitwise __be32;
-#if defined(__GNUC__)
 typedef __u64 __bitwise __le64;
 typedef __u64 __bitwise __be64;
-#endif
+
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
-- 
1.5.4.3




