Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZKJLak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZKJLak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZKJLaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:30:39 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:37503 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbZKJLai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:30:38 -0500
Date: Tue, 10 Nov 2009 12:27:37 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091110112737.GB2998@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk> <alpine.OSX.1.10.0911021057450.464@caridad.icculuslan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.1.10.0911021057450.464@caridad.icculuslan>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ryan C. Gordon <icculus@icculus.org> wrote:

> It's true that /bin/ls would double in size (although I'm sure at least 
> the download saves some of this in compression). But how much of, say, 
> Gnome or OpenOffice or Doom 3 is executable code? These things would be 
> nowhere near "vastly" bigger.

OO takes about 140 MB for binaries at my site. Now just multiply it by 
the number of targets you'd like to support.

Gnome stuff also tends to be quite fat.

> > 	- Assumes data files are not dependant on binary (often not true)
> 
> Turns out that /usr/sbin/hald's cache file was. That would need to be 
> fixed, which is trivial, but in my virtual machine test I had it delete 
> and regenerate the file on each boot as a fast workaround.

Well, hald (and already the dbus stuff) is a misdesign, so we shouldn't
count it here ;-P
 
> Testing doesn't really change with what I'm describing. If you want to 
> ship a program for PowerPC and x86, you still need to test it on PowerPC 
> and x86, no matter how you distribute or launch it.

BUT: you have to test the whole combination on dozens of targets.
And it in now way releaves to from testing dozens of different distros.

If you want one binary package for many different targets, go for 
autopackage, LSM, etc.

> Yes, that is true for software shipped via yum, which does not encompass 
> all the software you may want to run on your system. I'm not arguing 
> against package management.

Why not fixing the package ?

> True. If I try to run a PowerPC binary on a Sparc, it fails in any 
> circumstance. I recognize the goal of this post was to shoot down every 
> single point, but you can't see a scenario where this adds a benefit? Even 
> in a world that's still running 32-bit web browsers on _every major 
> operating system_ because some crucial plugins aren't 64-bit yet?

The root of evil are plugins - even worse: binary-only plugins.

Let's just take browsers: is there any damn good reason for not putting
those things into their own process (9P provides a fine IPC for that),
besides stupidity and lazyness of certain devs (yes, this explicitly
includes mozilla guys) ?
 
> > - Ship web browser plugins that work out of the box with multiple
> >   platforms.
> > 	- yum install just works, and there is a search path in firefox
> > 	  etc
> 
> So it's better to have a thousand little unique solutions to the same 
> problem? Everything has a search path (except things that don't), and all 
> of those search paths are set up in the same way (except things that 
> aren't). Do we really need to have every single program screwing around 
> with their own personal spiritual successor to the CLASSPATH environment 
> variable?

You dont like $PATH ? Use a unionfs and let a installer / package manager
handle proper setups.

Yes, on Linux (contrary to Plan9) this (AFAIK) still requires root 
privileges, but there're ways around this.

> > - Ship kernel drivers for multiple processors in one file.
> > 	- Not useful see separate downloads
> 
> Pain in the butt see "which installer is right for me?"   :)

It even gets worse: you need different modules for different kernel
versions *and* kernel configs. Kernel image and modules strictly 
belong together - it's in fact *one* kernel that just happens to be 
split off into several files so parts of it can be loaded on-demand.
 
> I don't want to get into a holy war about out-of-tree kernel drivers, 
> because I'm totally on board with getting drivers into the mainline. But 
> it doesn't change the fact that I downloaded the wrong nvidia drivers the 
> other day because I accidentally grabbed the ia32 package instead of the 
> amd64 one. So much for saving bandwidth.

NVidia is a bad reference here. These folks simply don't get their
stuff stable, instead playing around w/ ugly code obfuscation.
No mercy for those jerks.

I'm strongly in favour of prohibiting proprietary kernel drivers.
 
> I wasn't paying attention. But lots of people wouldn't know which to pick 
> even if they were. Nvidia, etc, could certainly put everything in one 
> shell script and choose for you, but now we're back at square one again.

If NV wants to stick in their binary crap, they'll have to bite the 
bullet of maintaining proper packaging. The fault is on their side,
not on Linux' one.

> > - Transition to a new architecture in incremental steps. 
> > 	- IFF the CPU supports both old and new
> 
> A lateral move would be painful (although Apple just did this very thing 
> with a FatELF-style solution, albeit with the help of an emulator), but if 
> we're talking about the most common case at the moment, x86 to amd64, it's 
> not a serious concern.

This is a specific case, which could be handled easily in userland, IMHO.

> Why install Gimp by default if I'm not an artist? Because disk space is 
> cheap in the configurations I'm talking about and it's better to have it 
> just in case, for the 1% of users that will want it. A desktop, laptop or 
> server can swallow a few megabytes to clean up some awkward design 
> decisions, like the /lib64 thing.

What's so especially bad on the multilib approach ?

> A few more megabytes installed may cut down on the support load for 
> distributions when some old 32 bit program refuses to start at all.

The distro could simply provide a few compat packages.
It even could use a hooked-up ld.so which does appropriate checks
and notify the package manager if some 32bit libs are missing.

> > - One hard drive partition can be booted on different machines with
> >   different CPU architectures, for development and experimentation. Same
> >   root file system, different kernel and CPU architecture. 
> > 
> > 	- Now we are getting desperate.
> 
> It's not like this is unheard of. Apple is selling this very thing for 129 
> bucks a copy.

Distro issue.
You need to have all packages installed for each supported arch *and*
all applications must be capable of handling different bytesex or
typesizes in their data.

> > - Prepare your app on a USB stick for sneakernet, know it'll work on
> >   whatever Linux box you are likely to plug it into.
> > 
> > 	- No I don't because of the dependancies, architecture ordering
> > 	  of data files, lack of testing on each platform and the fact
> > 	  architecture isn't sufficient to define a platform
> 
> Yes, it's not a silver bullet. Fedora will not be promising binaries that 
> run on every Unix box on the planet.
> 
> But the guy with the USB stick? He probably knows the details of every 
> machine he wants to plug it into...

Then he's most likely capable of maintaining a multiarch distro.
Leaving out binary application data (see above), it's not such a big
deal - just work-intensive. Using FatELF most likely increases that work.

> It's possible to ship binaries that don't depend on a specific 
> distribution, or preinstalled dependencies, beyond the existance of a 
> glibc that was built in the last five years or so. I do it every day. It's 
> not unreasonable, if you aren't part of the package management network, to 
> make something that will run, generically on "Linux."

Good, why do you need FatELF then ?

> There are programs I support that I just simply won't bother moving to 
> amd64 because it just complicates things for the end user, for example.

Why don't you just solve that in userland ?

> That is anecdotal, and I apologize for that. But I'm not the only 
> developer that's not in an apt repository, and all of these rebuttals are 
> anecdotal: "I just use yum [...because I don't personally care about 
> Debian users]."

Can't just just make up your own repo ? Is it so hard ?
Just can speak for Gentoo - overlays are quite convenient here.
 

cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
