Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbYEETB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbYEETB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762600AbYEETBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:01:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48458 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762428AbYEETBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:01:10 -0400
Date: Mon, 5 May 2008 21:01:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080505190145.GA4498@uranus.ravnborg.org>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu> <20080505182427.GA2025@uranus.ravnborg.org> <20080505184235.GD22332@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505184235.GD22332@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 08:42:35PM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > This is a many years old kconfig bug that is frequently hacked 
> > > around in distro kernel packages but which has been ignored upstream 
> > > - i've attached Fedora's nonint_oldconfig patch from Dave Jones 
> > > below. (maybe Arjan wrote it originally?)
> > 
> > In latest kbuild.git I've added a new feature.
> > 
> > 	make K=.config alldefconfig
> > 
> > would give you eaxtly what you request here. K= is used to say where 
> > to locate the base-configuration.
> 
> great, thanks Sam!
> 
> ( how hard would it be to fix the "make oldconfig < /dev/null" infinit 
>   loop bug btw? I've got this method in a number of scripts of mine and 
>   it's an intuitive thing to type anyway, i think users would like it if 
>   it Just Worked. )

Let me try (on my i386 box so I use x86_&4 so I know oldconfig will ask):
$ make defconfig ARCH=x86_64
#
# configuration is based on '/home/sam/kernel/kbuild.git/arch/x86/configs/x86_64_defconfig'
#
# configuration written to .config
#
$ make oldconfig > /dev/null
aborted!

Console input/output is redirected. Run 'make oldconfig' to update configuration.

make[1]: *** [oldconfig] Error 1
make: *** [oldconfig] Error 2



And then with a config that does not need an update:
$ make defconfig
#
# configuration is based on '/home/sam/kernel/kbuild.git/arch/x86/configs/i386_defconfig'
#
# configuration written to .config
#
$ make oldconfig > /dev/null
$

Seems like I already fixed it :-)
That was a side-effect of touching some code in conf.c

Note by the way the output of 'make oldconfig' - nada.
I simply dropped the chatty mode as noone used it
for anything sensible anymore.

	Sam
