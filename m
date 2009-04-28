Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZD1TTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZD1TTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZD1TTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:19:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58303 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZD1TTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:19:45 -0400
Date: Tue, 28 Apr 2009 21:18:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
Message-ID: <20090428191827.GA27062@elte.hu>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com> <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain> <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain> <20090428172226.GA15115@elte.hu> <alpine.DEB.2.00.0904281331040.8066@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904281331040.8066@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 28 Apr 2009, Ingo Molnar wrote:
> 
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > So yes, it would be good to automate it:
> > > 
> > > > If a tool was available to detect the hardware and create a 
> > > > config tailored for the box, this use for a default config would 
> > > > go away
> > > 
> > > Yeah, I've wished for that.
> > 
> > Steve (Cc:-ed) submitted such a script last year IIRC. It wasnt 
> > particularly complex.
> 
> I've submitted the script a few times to LKML but it is not 
> exactly what people want, but is quite useful in the mean time.
> 
> What people want is a script that will analyze their system 
> devices and enable all the configs that will support them.
> 
> My script requires that you have booted the kernel (or similar 
> kernel with the same config options and modules). It then runs 
> lsmod, and searches for the options that enable those modules. It 
> then reads the current .config file and prints out a new config 
> that disables all module configs that are not used to enable the 
> modules found with lsmod.
> 
> Here's the code (perl script):
> 
> http://rostedt.homelinux.com/code/streamline_config.pl
> 
> The instructions on how to use it are at the top of the file.
> 
> This script has brought down my full kernel compile times with 
> distcc from 50 minutes to under 10.

Looks rather useful IMHO.

I use the following magic incantation in cfs-debug-info.sh to get to 
the distro config automatically:

 KREL=`uname -r | sed 's/smp$//g'`
 ( cat "`rpm -ql kernel-$KREL 2>/dev/null | grep /boot/config`"
   cat "`rpm -ql kernel-smp-$KREL 2>/dev/null | grep /boot/config`"
   cat "`dpkg -L linux-image-$KREL 2>/dev/null | grep /boot/config`"
   cat /boot/config-$KREL 2>/dev/null
 )

Works on most .rpm and .deb based distros. (If /proc/config.gz is 
present that could be added too.)

So if this was added as a 'make builtinconfig' kind of shortcut, 
with no extra steps needed (and if the script bailed out if it 
cannot find the currently booted .config) - that would be a rather 
useful (and easy) way to start kernel development on a new box.

Useful to newbies and oldbies alike IMHO.

	Ingo
