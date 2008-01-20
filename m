Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYATAzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYATAzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 19:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYATAzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 19:55:01 -0500
Received: from ozlabs.org ([203.10.76.45]:50445 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbYATAzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 19:55:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [lguest build regression fix] Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
Date: Sun, 20 Jan 2008 11:54:18 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200801180035.42878.rjw@sisk.pl> <200801201024.47825.rusty@rustcorp.com.au> <20080119234945.GF8669@does.not.exist>
In-Reply-To: <20080119234945.GF8669@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801201154.19118.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 January 2008 10:49:45 Adrian Bunk wrote:
> On Sun, Jan 20, 2008 at 10:24:47AM +1100, Rusty Russell wrote:
> > On Sunday 20 January 2008 05:06:04 Ingo Molnar wrote:
> > >  # CONFIG_PARAVIRT_GUEST is not set
> > >  CONFIG_LGUEST_GUEST=y
> >
> > This looks like a "randconfig" bug, to be honest.
>
> According to GNU grep we have two CONFIG_LGUEST_GUEST variables (sic),
> one in arch/x86/lguest/Kconfig and one in drivers/lguest/Kconfig.
>
> Rusty, don't blame randconfig for finding bugs in this mess you
> created...

My apologies, it is my mess.  The one in drivers/lguest/Kconfig is the old
(bogus) one: looks like I lost the removal part in a patch merge back in
September.

I've tested this patch.  It correctly handles Ingo's config (removes lguest
guest support).  Both lguest and lguest guest support can be turned on
independently, and it still compiles.

How embarrassing,
Rusty.
---
Remove bogus duplicate CONFIG_LGUEST_GUEST entry.

It was moved to arch/x86/lguest/Kconfig, but I lost the deletion part in a
patch suffle.  My confused one-liner "fix" to turn it on is also reverted:
84f7466ee20cc094aa38617abfa2f3834871f054

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 3db2cadc1a30 drivers/lguest/Kconfig
--- a/drivers/lguest/Kconfig	Sun Jan 20 11:25:15 2008 +1100
+++ b/drivers/lguest/Kconfig	Sun Jan 20 11:47:57 2008 +1100
@@ -2,7 +2,6 @@ config LGUEST
 	tristate "Linux hypervisor example code"
 	depends on X86_32 && EXPERIMENTAL && !X86_PAE && FUTEX && !(X86_VISWS || X86_VOYAGER)
 	select HVC_DRIVER
-	select LGUEST_GUEST
 	---help---
 	  This is a very simple module which allows you to run
 	  multiple instances of the same Linux kernel, using the
@@ -11,9 +10,3 @@ config LGUEST
 	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
 
 	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
-
-config LGUEST_GUEST
-	bool
-	help
-	  The guest needs code built-in, even if the host has lguest
-	  support as a module.
