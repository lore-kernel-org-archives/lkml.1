Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZCWIIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZCWIIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbZCWIHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:07:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbZCWIHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:07:49 -0400
Date: Mon, 23 Mar 2009 09:07:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc8-rt2
Message-ID: <20090323080724.GA13569@elte.hu>
References: <1235619922.31774.17.camel@localhost.localdomain> <1236984825.10748.17.camel@localhost.localdomain> <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain> <1237661053.3196.10.camel@localhost.localdomain> <20090321184904.GA19352@elte.hu> <1237662372.3574.2.camel@localhost.localdomain> <1237663624.3200.3.camel@localhost.localdomain> <1237687635.3424.1.camel@localhost.localdomain> <20090322130937.GA22848@elte.hu> <1237758228.18021.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237758228.18021.8.camel@localhost.localdomain>
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


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> On Sun, 2009-03-22 at 14:09 +0100, Ingo Molnar wrote:
> > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > 
> > > On Sat, 2009-03-21 at 12:27 -0700, Fernando Lopez-Lezcano wrote:
> > > > On Sat, 2009-03-21 at 12:06 -0700, Fernando Lopez-Lezcano wrote:
> > > > > On Sat, 2009-03-21 at 19:49 +0100, Ingo Molnar wrote:
> > > > > > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > > > > > 
> > > > > > > Mar 21 10:47:43 localhost kernel: kernel tried to execute NX-protected
> > > > > > > page - exploit attempt? (uid: 0)
> > > > > > > Mar 21 10:47:43 localhost kernel: BUG: unable to handle kernel paging
> > > > > > > request at f6400800
> > > > > > 
> > > > > > kernel tried to execute some really weird address, probably via a 
> > > > > > function pointer.
> > > > > 
> > > > > Strangely enough rc8-rt1 boots (almost). _Exact_ same build with the
> > > > > exception of the change from rt1 -> rt2. 
> > > > > 
> > > > > Haldaemon does not start on boot (fails), if I login as root and start
> > > > > the haldaemon service manually it starts. And then things seem to work
> > > > > fine (I'm writing this email from that machine). Still investigating...
> > > > 
> > > > First problem was due to old firmware for the iwl3945 hardware. I
> > > > updated to the latest and hal started fine (this is on fc9). 
> > > > 
> > > > Now another one related to xorg/drm...
> > > 
> > > Scratch that, I had an old version of xorg/drm installed in this 
> > > particular machine and the new kernel did not like it. Seems to 
> > > boot fine now... sorry for the noise.
> > 
> > No problem :-)
> > 
> > I'm wondering, do you have any theory about how the old firmware 
> > cause that weird NX-fault kernel crash? For a few minutes i took it 
> > for an x86 crash.
> 
> Sorry, no theories at all - I would have to be a kernel guru for that. I
> was surprised the whole thing went away with the firmware upgrade (I saw
> some message in /var/log/messages telling me the firmware was old) - it
> did seem like something more serious. 
> 
> I hit another problem. On a quad code intel machine here at home there
> is a problem during shutdown. The final shutdown dies with a traceback
> (something like "rc0 was killed by SIGSEGV" or similar words at the very
> end). Then I have to push the power button for x+ seconds to force a
> power off. 
> 
> Should I post a picture of the screen as it is at that point, or just
> send that to you and Thomas? 

any kernel stack dump in that?

You could try to do this before shutting down:

  echo 1 > /proc/sys/kernel/print-fatal-signals
  dmesg -n 8

that way there's a (hopefully helpful) stack dump done of the 
SIGSEGV itself.

	Ingo
