Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZE1Wq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZE1Wq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZE1WqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:46:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:34666 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZE1WqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:46:18 -0400
Subject: Re: [regression, bisected] adb trackpad disappears after suspend
 to ram
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200905281858.37729.rjw@sisk.pl>
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	 <87prdt3bgb.fsf@scholz.fias.uni-frankfurt.de>
	 <200905281858.37729.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 29 May 2009 08:23:42 +1000
Message-Id: <1243549422.17903.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We are too late in the cycle to revert this commit and it really is needed to
> fix a more serious issue.  Nevertheless knowing that it caused the problem to
> appear on your system is also important.
> 
> Ben, do you have an idea what may be going on here?  Does __disable_irq() mask
> the interrupt on this platform?

I suppose so :-) I'll have to check what's going on, it's not
immediately clear to me.

Cheers,
Ben.

> > To those of you I cc'ed: sorry for the noise, but you were the ones that
> > get_maintainers.pl spit out when asking for *adb*-files.
> > 
> > In addition to the diff of the lshal output I posted before, here is the
> > diff in the output of lsadb:
> > 
> > --- lsadb-ok.out	2009-05-28 08:53:09.000000000 +0200
> > +++ lsadb-notouchpad.out	2009-05-28 08:55:59.000000000 +0200
> > @@ -1,35 +1,24 @@
> >  
> >  Devices connected to the ADB-Bus: (PMU: 12)
> >  
> >    D R  raw data                  decoded data
> >  -------------------------------------------------------------------------------------
> >    2.3: [62 c4]                   Encode Device
> >                                   Apple Macintosh PowerBook G3 Keyboard (ISO layout)
> >                                   Exceptional Event enabled
> >                                   Service Request enabled
> >      2: [ff ff]                   Qualifier: (not all must be supported)
> >                                    Fn-key   Delete   Caps-Lock   Reset      Control 
> >                                    Shift    Option   Apple       Num-Lock   Scroll-Lock 
> >                                    Scroll-Lock-LED   Caps-Lock-LED   Num-Lock-LED 
> >      1: [05 01]                   Special keys need Fn Key
> >      0: 
> >  
> > -  3.3: [23 04]                   Relative-Position Device
> > -                                 Extended Mouse Protokoll 
> > -                                 Exceptional Event disabled
> > -                                 Service Request enabled
> > -    2: [08 48 03 00 00 00 00 00]
> > -    1: [74 70 61 64 01 90 03 04] Mouse type:   tpad
> > -                                 resolution:   400 dpi
> > -                                 Device class: Trackpad
> > -                                 buttons:      4
> > -    0: 
> > -
> >    7.3: [67 1f]                   Misc. Device
> >                                   Powerbook G3 (Pismo) Button Device 
> >                                   Exceptional Event enabled
> >                                   Service Request enabled
> >      2: 
> >      1: 
> >      0:  
> > 
> > >
> > > Here is a diff of the output of lshal before and after the trackpad vanished:
> > >
> > > --- lshal-ok.out	2009-05-25 17:00:28.000000000 +0200
> > > +++ lshal-notouchpad.out	2009-05-25 17:04:42.000000000 +0200
> > > @@ -1,5 +1,5 @@
> > >  
> > > -Dumping 81 device(s) from the Global Device List:
> > > +Dumping 80 device(s) from the Global Device List:
> > >  -------------------------------------------------
> > >  udi = '/org/freedesktop/Hal/devices/computer'
> > >    info.addons = {'hald-addon-cpufreq'} (string list)
> > > @@ -95,21 +95,6 @@
> > >    linux.subsystem = 'input'  (string)
> > >    linux.sysfs_path = '/sys/devices/virtual/input/input4/event4'  (string)
> > >  
> > > -udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_2'
> > > -  info.capabilities = {'input', 'input.mouse'} (string list)
> > > -  info.category = 'input'  (string)
> > > -  info.parent = '/org/freedesktop/Hal/devices/computer'  (string)
> > > -  info.product = 'ADB mouse'  (string)
> > > -  info.subsystem = 'input'  (string)
> > > -  info.udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_2'  (string)
> > > -  input.device = '/dev/input/event3'  (string)
> > > -  input.product = 'ADB mouse'  (string)
> > > -  input.x11_driver = 'evdev'  (string)
> > > -  linux.device_file = '/dev/input/event3'  (string)
> > > -  linux.hotplug_type = 2  (0x2)  (int)
> > > -  linux.subsystem = 'input'  (string)
> > > -  linux.sysfs_path = '/sys/devices/virtual/input/input3/event3'  (string)
> > > -
> > >  udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_1'
> > >    info.addons.singleton = {'hald-addon-input'} (string list)
> > >    info.capabilities = {'input', 'input.keys', 'button'} (string list)
> > > @@ -1820,6 +1805,6 @@
> > >    pci.vendor_id = 4203  (0x106b)  (int)
> > >  
> > >  
> > > -Dumped 81 device(s) from the Global Device List.
> > > +Dumped 80 device(s) from the Global Device List.
> > >  ------------------------------------------------
> > >
> > > Please let me know if you need more info.
> 
> I'd like to see a boot log, preferably containing a suspend-resume in which
> the problem was reproduced.
> 
> Best,
> Rafael

