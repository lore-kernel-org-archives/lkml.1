Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbXD2BC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbXD2BC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 21:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXD2BC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 21:02:58 -0400
Received: from mx27.mail.ru ([194.67.23.64]:10851 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbXD2BC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 21:02:56 -0400
Date: Sun, 29 Apr 2007 05:01:02 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <gregkh@suse.de>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-ID: <20070429010102.GA3735@zarina>
Reply-To: cbou@mail.ru
References: <20070426232902.GA10423@zarina> <20070428045148.9f1ba191.akpm@linux-foundation.org> <20070428123129.GA2056@zarina> <20070428120804.67098b2c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070428120804.67098b2c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 12:08:04PM -0700, Andrew Morton wrote:
> On Sat, 28 Apr 2007 16:31:29 +0400 Anton Vorontsov <cbou@mail.ru> wrote:
> 
> > On Sat, Apr 28, 2007 at 04:51:48AM -0700, Andrew Morton wrote:
> > > On Fri, 27 Apr 2007 03:29:02 +0400 Anton Vorontsov <cbou@mail.ru> wrote:
> > > 
> > > > To not confuse with David own battery-2.6 repository, it's called
> > > > battery2-2.6, and can be found here:
> > > > 
> > > > http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=summary
> > > > 
> > > > You can get it using "git clone --reference linux-2.6 \
> > > > git://git.infradead.org/users/cbou/battery2-2.6.git" command.
> > > 
> > > i386 `make allmodconfig':
> > > 
> > > ERROR: "battery_is_external_power_supplied" [drivers/battery/ds2760_battery.ko] undefined!
> > > ERROR: "battery_unregister" [drivers/battery/ds2760_battery.ko] undefined!
> > > ERROR: "battery_register" [drivers/battery/ds2760_battery.ko] undefined!
> > > ERROR: "battery_status_changed" [drivers/battery/ds2760_battery.ko] undefined!
> > 
> > :-/
> > 
> > It should be fixed 37 hours ago by
> > 
> > http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=commit;h=cbb1e1b9e3a2cbf62ce4c13ef95d146ebc5e7274
> 
> I had that.  I just did a fresh fetch and it still happens

  %-[       ]|floor

Andrew, I'm wondering if "make clean" would help...

I'm not lying, it works here. :-/

> akpm2:/usr/src/25> cd /usr/src/git26
> akpm2:/usr/src/git26> cat .git/branches/git-battery 
> git://git.infradead.org/users/cbou/battery2-2.6.git
> akpm2:/usr/src/git26> git-fetch git-battery
> akpm2:/usr/src/git26> git-checkout git-battery 
> Switched to branch "git-battery"
> akpm2:/usr/src/git26> setenv ARCH i386
> akpm2:/usr/src/git26> make allmodconfig > /dev/null
> akpm2:/usr/src/git26> make vmlinux modules

I've done these steps, 1:1, copy-pasted, assuming that
git26 is Linus' tree.

So, I have:

cbou:~/linux-2.6$ git log --pretty=oneline | head -n 15
045e09c3c8c71d41e9b2d98f2781cf0fa19ac3f9 Apple PMU Battery Kconfig: should also depend on BATTERY
8a7c6667b37e9fe407f68c4a53b8ff90e375d06a pda_power: fix copy-paste artifact
5f2a90ceccd3cc25a607c5658e986d07aa660a40 apm_power: add ability to calculate capacity using energy
ed2702e9eedb16c65017cbd1313fdc7ee3f2c5ff pmu_battery: Apple PMU battery initial commit
d38e1fb5612d950d64d09b2513af85edaa696d71 battery: add "model_name" and "present" attributes
cbb1e1b9e3a2cbf62ce4c13ef95d146ebc5e7274 battery: fix modular build
c565f9872f7f84f5e62b5ec1c90f140d443b756c ds2760_battery: use less "#ifdefs"
fe0c0cd7c0f98f479b2d2895194460139cec566a ds2760 W1 slave
bbb555a9edc8c5610ec5351bf984b6477d7486d4 remove "#if 0" from find_bus function, export it.
ed061df82fbbb6d2228e9d1d5051a6f70b6849bd 1-Wire ds2760 chip battery driver
a3e39e1b92d5cbe4a51be5f33208868dcf14da35 APM emulation driver for class batteries
8f6b1c2027c967ac9fe69a2cca74a0e682189e5a Universal battery class
fa1099f32ef0d2dc64b09a1de034167cf0db1f37 pda power driver
a9d7bc2ccadd2b6cb7eee75664c73fb75c58fa08 External power framework
de46c33745f5e2ad594c72f2cf5f490861b16ce1 Linux 2.6.21

cbou:~/linux-2.6$ git status
# On branch git-battery
nothing to commit (working directory clean)

> ....
> WARNING: "battery_is_external_power_supplied" [drivers/battery/ds2760_battery.ko] undefined!
> WARNING: "battery_unregister" [drivers/battery/ds2760_battery.ko] undefined!
> WARNING: "battery_register" [drivers/battery/ds2760_battery.ko] undefined!
> WARNING: "battery_status_changed" [drivers/battery/ds2760_battery.ko] undefined!
> make[1]: *** [__modpost] Error 1

And logs:

cbou:~/linux-2.6$ export ARCH=i386
cbou:~/linux-2.6$ make allmodconfig > /dev/null
cbou:~/linux-2.6$ make vmlinux modules
...
  CC [M]  drivers/battery/battery_core.o
  CC [M]  drivers/battery/battery_sysfs.o
  CC [M]  drivers/battery/battery_leds.o
  LD [M]  drivers/battery/battery.o
  CC [M]  drivers/battery/ds2760_battery.o
  LD      drivers/block/built-in.o
  CC [M]  drivers/block/floppy.o
...
  LD      drivers/power/built-in.o
  CC [M]  drivers/power/external_power.o
  CC [M]  drivers/power/pda_power.o
...
  CC      drivers/battery/battery.mod.o
  LD [M]  drivers/battery/battery.ko
  CC      drivers/battery/ds2760_battery.mod.o
  LD [M]  drivers/battery/ds2760_battery.ko
  CC      drivers/block/DAC960.mod.o
  LD [M]  drivers/block/DAC960.ko
  CC      drivers/block/aoe/aoe.mod.o
...
  CC      drivers/power/external_power.mod.o
  LD [M]  drivers/power/external_power.ko
  CC      drivers/power/pda_power.mod.o
  LD [M]  drivers/power/pda_power.ko
...
  LD [M]  sound/usb/snd-usb-lib.ko
  CC      sound/usb/usx2y/snd-usb-usx2y.mod.o
  LD [M]  sound/usb/usx2y/snd-usb-usx2y.ko
cbou:~/linux-2.6$ 


Here is my setup:

cbou:~$ make -v
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for i686-pc-linux-gnu

cbou:~$ gcc -v
Using built-in specs.
Target: i686-pc-linux-gnu
Configured with: ../gcc-4.1.2/configure --prefix=/usr --libexecdir=/usr/lib --enable-languages=c,c++ --enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu --enable-shared --disable-nls --with-x=no
Thread model: posix
gcc version 4.1.2 (CRUX)

cbou:~$ ld -v
GNU ld version 2.17.50.0.12 20070128

> > Though, I'm doing "allmodconfig" once again, to be sure, it will take
> > some time. (I've done defconfig, with modular W1, BATTERY,
> > DS2760_BATTERY already, and error doesn't show up).
> > 
> 
> You did `make vmlinux modules'?

No, previously I did "make", i.e. "all" target. It's should be exactly
vmlinux and modules.. But now, I just copy-pasted your steps, and done
exactly what you've done. No errors.

> > I have one question though... battery2-2.6 have two branches,
> > "linus" (clean Linus' tree) and "master" (with battery stuff).
> 
> hm, I'm not using the "battery" branch.  Should I?

No no. There is no "battery" branch, only "master" and "linus".
Default is "master", and "linus" is just clean Linus' tree. So
everything is correct.

> > When I'll want to sync battery tree with Linus' once again,
> > should I just pull from linus, or it's better to rebase master against
> > linus, and then "git push -f" to the battery2-2.6 master branch?
> > Or it will break something on your side (as commits will change their
> > hash)?
> 
> I always do `git-branch -d git-battery' prior to every pull, so rebasings
> like that are OK.

Nice, thanks!

Sincerely,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
