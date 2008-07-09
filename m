Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYGIUFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYGIUFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYGIUE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:04:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYGIUE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:04:58 -0400
Date: Wed, 9 Jul 2008 22:04:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies (was:
	Re: [PATCH 00 of 55] xen64: implement 64-bit Xen support)
Message-ID: <20080709200428.GB14009@elte.hu>
References: <patchbomb.1215554782@localhost> <20080709195218.GA9608@elte.hu> <200807092159.35288.rjw@sisk.pl> <200807092202.27013.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807092202.27013.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > This combination actually doesn't make sense whatsoever.
> > 
> > PM_SLEEP depends (indirectly) on PM and the fact that it's possible 
> > to use a .config violating this dependency is a build system 
> > problem, really.
> 
> Your patch is correct, though. :-)

yes, that combination doesnt make sense in -git, but tip/xen64 tries the 
!PM && PM_SLEEP combination - see the patch below. What do you think 
about that patch?

I think Jeremy's patch makes sense, but no strong feelings. We can 
certainly map out these side-effects. (the fixes you've been Cc:-ed to 
should be roughly all that can happen i think.)

	Ingo

------------------->
commit 6fbbec428c8e7bb617da2e8a589af2e97bcf3bc4
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Tue Jul 8 15:07:08 2008 -0700

    suspend, xen: enable PM_SLEEP for CONFIG_XEN
    
    Xen save/restore requires PM_SLEEP to be set without requiring
    SUSPEND or HIBERNATION.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Cc: Stephen Tweedie <sct@redhat.com>
    Cc: Eduardo Habkost <ehabkost@redhat.com>
    Cc: Mark McLoughlin <markmc@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index b45da40..1436c47 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -82,7 +82,7 @@ config PM_SLEEP_SMP
 
 config PM_SLEEP
 	bool
-	depends on SUSPEND || HIBERNATION
+	depends on SUSPEND || HIBERNATION || XEN
 	default y
 
 config SUSPEND

