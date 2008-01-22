Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYAVOj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYAVOj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYAVOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:39:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53727 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbYAVOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:39:51 -0500
Date: Tue, 22 Jan 2008 15:39:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080122143912.GJ7304@elte.hu>
References: <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com> <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu> <4790A385.800@free-electrons.com> <1200664214.4001.24.camel@cinder.waste.org> <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org> <20080118210938.GE10717@elte.hu> <1200695950.25782.28.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200695950.25782.28.camel@cinder.waste.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Matt Mackall <mpm@selenic.com> wrote:

> > btw., are there any pending arch/x86 bits in -tiny? (stupid 
> > question: were can i get the most uptodate version of -tiny from?)
> 
> It's not a stupid question. I dropped updating the tree regulary some 
> time ago to focus on merging bits and then got a bit side-tracked by 
> this little thing called "version control".
> 
> Michael is attempting to get the tree started again and has put a 
> quilt up here:
> 
> http://elinux.org/images/3/3c/Tiny-quilt-2.6.23-0.tar.bz2

cool! A few comments about the patches that affect arch/x86:

dmi_blacklist.patch:

  +#ifdef CONFIG_DMI_SCAN
          dmi_scan_machine();
  +#endif

put that #ifdef into the include file and make it an inlined NOP in the 
!DMI_SCAN case. That de-#ifdef-ifies the .c files.

cpu-support.patch: ditto.

mtrr.patch: ditto.

inflate-error.patch: please use:

   quilt refresh --diffstat --sort --no-timestamps -p 1

when generating patches, to make them reviewable, uniform and 
noise-free.

no-doublefault.patch: looks ok. Please add proper metadata and submit to 
lkml.

sbf.patch: looks ok.

sysenter.patch:

+#ifdef CONFIG_SYSENTER
        sysenter_setup();
        enable_sep_cpu();
+#endif

hide these #ifdefs in the include file. (as it already does) Looks ok 
otherwise.

threadinfo-ool.patch: doesnt this break the scheduler? Had something 
like this in -rt, i turned 'current' into a const actually, but had 
trouble with keeping from gcc to do the right thing in sched.c. I guess 
we could live with current_non_const() that gets it from assembly. (and 
hence gcc wont be able to optimize it away in the middle of the 
context-switch) But when done properly, this is both a nice, measurable 
speedup on UP, and a nice space-saver.

tiny-cflags.patch: obsolete? Isnt CFLAGS already extendable? Question to 
Sam i guess.

tsc.patch: look ok. needs x86.git porting.

	Ingo
