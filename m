Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYJQNFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYJQNFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYJQNFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:05:35 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:41266 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYJQNFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BEDi0Ja5Jjy3iAqTJo/XpUjoDDpDI9qI8D8V6NQiJC1icSaqjn4DpYnY5lz3IJb5cU
         6Cv4UaUH4oZFE6cdfKEfONjbAEosFTddLRT4XVaDF6Oa21rbzHOMUJBZUHRw7ZSF9pea
         gPykhyj4KqIfa1WVv7V8j0HdCMLZvWbUNPgyQ=
Message-ID: <b9df5fa10810170605t50e366e9nf62f8a18df37fc3c@mail.gmail.com>
Date: Fri, 17 Oct 2008 19:05:32 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] init: Properly placing noinline keyword.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here, noinline keyword should be placed between storage class and type.
Thanks.

Signed-off-by: Md.Rakib H. Mullick(rakib.mullick@gmail.com)

--- linux-2.6-stable.orig/init/main.c	2008-10-16 20:04:15.000000000 +0600
+++ linux-2.6-stable/init/main.c	2008-10-16 20:59:29.562096784 +0600
@@ -457,7 +457,7 @@ static void __init setup_command_line(ch
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */

-static void noinline __init_refok rest_init(void)
+static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
@@ -792,7 +792,7 @@ static void run_init_process(char *init_
 /* This is a non __init function. Force it to be noinline otherwise gcc
  * makes it inline to init() and it becomes part of init.text section
  */
-static int noinline init_post(void)
+static noinline int init_post(void)
 {
 	free_initmem();
 	unlock_kernel();
