Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbZHUOfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbZHUOfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbZHUOfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:35:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbZHUOfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:35:50 -0400
Date: Fri, 21 Aug 2009 16:35:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-ID: <20090821143525.GH11098@elte.hu>
References: <20090819025634.987354707@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819025634.987354707@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Here's my rebase of the prior push of streamline-config.pl.
> 
> What this patch series does, is add my streamline-config.pl as a 
> make option for users. What streamline-config.pl does is to look 
> at the modules loaded in the system (lsmod) and then scans all the 
> Makefiles and Kconfigs in the current directory tree to find what 
> configs need to be set for the modules that are loaded.
> 
> It then looks at the .config (if .config is not found, it looks in 
> /boot, /proc/config.gz, vmlinux, configs.ko for .configs that it 
> may be able to use). This script will remove all options set as =m 
> that does not need to be set in order to build the modules found 
> by lsmod.
> 
> NOTE: This does not touch any =y option. If you do make 
> allyesconfig and then run this, it will have not effect anything. 
> Nor does this enable any thing that is not set. Although we may 
> change this in the future.
> 
> This patch series provides:
> 
>   make localmodconfig
> 
> which will look for a .config to streamline. Then it will run 
> silentoldconfig to clean up any missing options.
> 
>   make localyesconfig
> 
> will remove all =m that is not needed to build the modules 
> provided by lsmod, and then convert the rest to =y. Note, once you 
> do this, no more changes will be made by these scripts.
> 
> This is idea to help testers. Since a lot of people download a 
> kernel from kernel.org and then uses the distro config to 
> configure it. This can take hours to build. Now all a tester needs 
> to do, is to download the kernel from kernel.org and run "make 
> localmodconfig". This will disable most of the modules that are 
> set in distro kernels and speed up the build time by magnitudes!
> 
> Lets try to get this in soon,

btw., the way i tested this in the past (and which i dont have time 
to test right now) is that i took a plain Fedora box with a regular 
rpm kernel booted up and typed:

	make localyesconfig

and built it and then 1) checked the size of the .config (it should 
be much smaller than allyesconfig) and 2) tried to boot the 
resulting bzImage.

It either didnt boot in the past, or had a very large .config. It 
would be nice if you could check whether it does on a box of yours. 
(maybe you already did that!)

	Ingo
