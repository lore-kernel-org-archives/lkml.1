Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbXHAGbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbXHAGbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXHAGbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:31:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50103 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXHAGbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:31:09 -0400
Date: Wed, 1 Aug 2007 08:31:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lenar =?iso-8859-1?Q?L=F5hmus?= <lenar@city.ee>
Cc: Klaus Schulz <Klaus.Schulz@web.de>, ck@vds.kolivas.org,
       linux-kernel@vger.kernel.org
Subject: Re: ck vs. cfs : realtime audio performance
Message-ID: <20070801063102.GB10134@elte.hu>
References: <1185870355.7933.55.camel@klaus-laptop> <1185886161.7397.11.camel@klaus-laptop> <46AF3111.7090206@city.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AF3111.7090206@city.ee>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >Am Dienstag, den 31.07.2007, 10:26 +0200 schrieb Klaus Schulz:

> >>I am currently testing the 2.6.22.1 cfs-rt9 vs. ck1 on my rather pure
> >>realtime high-end-audio setup. (NO X, just a terminal, streaming .wav. 
> >>I am using my own written player and brutefir as the audio engine.)
> >>Comment: This is not a standard (amarok or xmms setup), all buffers in
> >>the chain are very small. Any problem will immidetialy end up in xruns.
> >>The sounddriver, HW (pci-bus etc.) are tweaked accordingly 
> >>
> >>Until now ck1 on 2.6.22 is giving me better results (less audible
> >>distortions) and runs extremely stable compared to cfs. 
> >>Under ck I ran my player with schedtool -R -p 98, which was better than
> >>running it e.g. with nice -20 
> >>Both setups under cfs were giving me worse results than ck.
> >>With CFS I also experienced XRUNS from time to time, what never happened
> >>with ck.
> >>
> >>However:
> >>
> >>When looking at the latest performance statistics cfs vs. ck which are
> >>spread around here, I am wondering, what might cause the differences.
> >>
> >>With ck I tweaked the rr_interval to 6 and was running at 10000Hz,
> >>which caused obvious improvements.
> >>
> >>These options I do not have with CFS.
> >>
> >>I am wondering if sched_granularity_ns should be touched when using cfs.
> >>I googled somewhere that bringing it down to e.g. 250000 instead of
> >>4000000 would smoothen the audio playback. I havn't tried it yet. I am
> >>wondering if this tweak is still applicable.

(re-sending my earlier reply to Klaus here on lkml too)

Klaus,

since you are using -rt, have you tried chrt-ing not only your audio
player but your audio IRQ as well? While playback is going on could you
create a system snapshot with the following tool:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and send me the output file.

i'm also wondering why HZ=10000 makes a difference - audio interrupts
have no Linux-timer aspect normally (they are hardware timers in essence
themselves) - which portion of the workload is timing out so that HZ
shows up? Does the enabling of CONFIG_HIGH_RES_TIMERS help perhaps?

Also, do you have any advice for me how to reproduce your problem? I've
got a couple of PCs with various low-end/chipset-based audio hw, but the
buffers are generally large (around 500 msecs) so i rarely run into any
xrun problems. Is your player available for download so i could try it?

	Ingo
