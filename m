Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYGXX2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYGXX2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbYGXX1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:27:54 -0400
Received: from gw.goop.org ([64.81.55.164]:38201 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbYGXX1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:27:51 -0400
Message-ID: <48890FF2.9070005@goop.org>
Date: Thu, 24 Jul 2008 16:27:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] memparse(): constify argument
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memparse()'s first argument can be const, so it should be.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/kernel.h |    2 +-
 lib/cmdline.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

===================================================================
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -174,7 +174,7 @@
 
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
-extern unsigned long long memparse(char *ptr, char **retptr);
+extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
===================================================================
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -126,9 +126,9 @@
  *	megabyte, or one gigabyte, respectively.
  */
 
-unsigned long long memparse (char *ptr, char **retptr)
+unsigned long long memparse(const char *ptr, char **retptr)
 {
-	unsigned long long ret = simple_strtoull (ptr, retptr, 0);
+	unsigned long long ret = simple_strtoull(ptr, retptr, 0);
 
 	switch (**retptr) {
 	case 'G':


