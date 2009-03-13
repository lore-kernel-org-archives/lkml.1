Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbZCMDcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbZCMDcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZCMDcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:32:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZCMDcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:32:04 -0400
Date: Fri, 13 Mar 2009 04:31:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: x86-microcode: get rid of set_cpus_allowed()
Message-ID: <20090313033146.GB11355@elte.hu>
References: <1236627539.5168.48.camel@earth> <200903111714.37444.rusty@rustcorp.com.au> <20090312174010.GI20716@alberich.amd.com> <20090312175807.GJ20716@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312175807.GJ20716@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.2
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.2 required=5.9 tests=BAYES_00,TVD_SUBJ_WIPE_DEBT autolearn=no SpamAssassin version=3.2.3
	2.7 TVD_SUBJ_WIPE_DEBT     TVD_SUBJ_WIPE_DEBT
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Thu, Mar 12, 2009 at 06:40:10PM +0100, Andreas Herrmann wrote:
> > On Wed, Mar 11, 2009 at 07:44:37AM +0100, Rusty Russell wrote:
> > > On Tuesday 10 March 2009 06:08:59 Dmitry Adamushko wrote:
> > > > 
> > > > Hi,
> > > > 
> > > > 
> > > > here is a possible candidate for Rusty's cpumask-refactored series.
> > > > Note the [*] remark below though.
> > > 
> > > Ah, OK, I'll drop my version then (below) in favor of this, and will
> > > push to Ingo with the others if he doesn't take it directly.
> > 
> > Sorry guys -- for the late reply --
> > but I missed Dmitry's mail due to some silly mail filtering and had to
> > restore his mail ...
> > 
> > Now I've tested both patches and both seem to reliably prevent
> > microcode updates on CPU1 and CPU2 of an Phenom X3 after
> > suspend/resume. (Just CPU0 was updated.)
> > 
> > Then I've tested mainline kernel w/o your patches and I've observed
> > similar problems. I've seen that sometimes ucode of CPU0 was not
> > updated and sometimes CPU1 and CPU2 were not updated.
> > 
> > I'll look into this asap.
> 
> Some further testing seem to indicate that suspend/resume does not
> work when I have done CPU hotplug before.
> 
> During today's tests I did:
> 
> (1) set offline/online CPU 1 and 2
> (2) perform suspend/resume afterwards
> 
> After that microcode update failed on some CPUs when performing
> suspend/resume. (When skipping step 1, microcode update during
> suspend/resume works.)
> 
> Looks strange, but should be debuggable.

That's with latest tip:master? Which commit should be reverted?

	Ingo
