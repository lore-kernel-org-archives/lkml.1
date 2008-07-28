Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYG1NBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYG1NBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYG1NA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:00:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYG1NA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:00:57 -0400
Date: Mon, 28 Jul 2008 15:00:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] memparse(): constify argument
Message-ID: <20080728130038.GG5515@elte.hu>
References: <48890FF2.9070005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48890FF2.9070005@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> memparse()'s first argument can be const, so it should be.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

this one clashed with upstream commit v2.6.26-6912-gfd19382, i've fixed 
it up as below.

	Ingo

-------
Subject: generic, memparse(): constify argument
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Thu, 24 Jul 2008 16:27:46 -0700

memparse()'s first argument can be const, so it should be.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |    2 +-
 lib/cmdline.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

===================================================================
Index: tip/include/linux/kernel.h
===================================================================
--- tip.orig/include/linux/kernel.h
+++ tip/include/linux/kernel.h
@@ -176,7 +176,7 @@ extern int vsscanf(const char *, const c
 
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
-extern unsigned long long memparse(char *ptr, char **retptr);
+extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
Index: tip/lib/cmdline.c
===================================================================
--- tip.orig/lib/cmdline.c
+++ tip/lib/cmdline.c
@@ -126,7 +126,7 @@ char *get_options(const char *str, int n
  *	megabyte, or one gigabyte, respectively.
  */
 
-unsigned long long memparse(char *ptr, char **retptr)
+unsigned long long memparse(const char *ptr, char **retptr)
 {
 	char *endptr;	/* local pointer to end of parsed string */
 
