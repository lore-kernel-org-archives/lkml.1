Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZD1VXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZD1VXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZD1VXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:23:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55834 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbZD1VXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:23:12 -0400
Date: Tue, 28 Apr 2009 17:23:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <20090428191827.GA27062@elte.hu>
Message-ID: <alpine.DEB.2.00.0904281721470.8066@gandalf.stny.rr.com>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com> <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
 <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain> <20090428172226.GA15115@elte.hu> <alpine.DEB.2.00.0904281331040.8066@gandalf.stny.rr.com> <20090428191827.GA27062@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Apr 2009, Ingo Molnar wrote:
> > 
> > My script requires that you have booted the kernel (or similar 
> > kernel with the same config options and modules). It then runs 
> > lsmod, and searches for the options that enable those modules. It 
> > then reads the current .config file and prints out a new config 
> > that disables all module configs that are not used to enable the 
> > modules found with lsmod.
> > 
> > Here's the code (perl script):
> > 
> > http://rostedt.homelinux.com/code/streamline_config.pl
> > 
> > The instructions on how to use it are at the top of the file.
> > 
> > This script has brought down my full kernel compile times with 
> > distcc from 50 minutes to under 10.
> 
> Looks rather useful IMHO.

There's one little bug. It does not catch configs that are modules that 
depend on other configs as modules (but do not have modules mapped).

I can fix this by also scanning the Kconfig* files, and include any 
"depends on" as well.

> 
> I use the following magic incantation in cfs-debug-info.sh to get to 
> the distro config automatically:
> 
>  KREL=`uname -r | sed 's/smp$//g'`
>  ( cat "`rpm -ql kernel-$KREL 2>/dev/null | grep /boot/config`"
>    cat "`rpm -ql kernel-smp-$KREL 2>/dev/null | grep /boot/config`"
>    cat "`dpkg -L linux-image-$KREL 2>/dev/null | grep /boot/config`"
>    cat /boot/config-$KREL 2>/dev/null
>  )
> 
> Works on most .rpm and .deb based distros. (If /proc/config.gz is 
> present that could be added too.)
> 
> So if this was added as a 'make builtinconfig' kind of shortcut, 
> with no extra steps needed (and if the script bailed out if it 
> cannot find the currently booted .config) - that would be a rather 
> useful (and easy) way to start kernel development on a new box.
> 
> Useful to newbies and oldbies alike IMHO.

Yes, it would be nice to automate this.

-- Steve

