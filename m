Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbYEUBMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbYEUBMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932259AbYEUBMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:12:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38175 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765895AbYEUBMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:12:08 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] provide out-of-line strcat() for m68k
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-Id: <E1JycsB-0000M9-36@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:12:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 788
Lines: 30

Whether we sidestep it in init/main.c or not, such situations
will arise again; compiler does generate calls of strcat()
on optimizations, so we really ought to have an out-of-line
version...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/lib/string.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/lib/string.c b/arch/m68k/lib/string.c
index 891e134..4253f87 100644
--- a/arch/m68k/lib/string.c
+++ b/arch/m68k/lib/string.c
@@ -15,6 +15,12 @@ char *strcpy(char *dest, const char *src)
 }
 EXPORT_SYMBOL(strcpy);
 
+char *strcat(char *dest, const char *src)
+{
+	return __kernel_strcpy(dest + __kernel_strlen(dest), src);
+}
+EXPORT_SYMBOL(strcat);
+
 void *memset(void *s, int c, size_t count)
 {
 	void *xs = s;
-- 
1.5.3.GIT


