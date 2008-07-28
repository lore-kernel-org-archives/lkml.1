Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYG1NLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYG1NLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYG1NLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:11:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYG1NLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:11:35 -0400
Date: Mon, 28 Jul 2008 15:11:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] memparse(): constify argument
Message-ID: <20080728131119.GH5515@elte.hu>
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

i've picked this up into tip/core/lib - if Andrew wants to have the same 
commit ID it can be pulled from there, as per the coordinates below.

I've merged that branch into tip/x86/xen, and i've applied your other 
two dependent changes to tip/x86/xen too.

	Ingo

------------------>

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/lib

Jeremy Fitzhardinge (1):
      generic, memparse(): constify argument


 include/linux/kernel.h |    2 +-
 lib/cmdline.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fdbbf72..7889c2f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -176,7 +176,7 @@ extern int vsscanf(const char *, const char *, va_list)
 
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
-extern unsigned long long memparse(char *ptr, char **retptr);
+extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
diff --git a/lib/cmdline.c b/lib/cmdline.c
index 5ba8a94..f5f3ad8 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -126,7 +126,7 @@ char *get_options(const char *str, int nints, int *ints)
  *	megabyte, or one gigabyte, respectively.
  */
 
-unsigned long long memparse(char *ptr, char **retptr)
+unsigned long long memparse(const char *ptr, char **retptr)
 {
 	char *endptr;	/* local pointer to end of parsed string */
 
