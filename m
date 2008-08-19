Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYHSPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYHSPTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYHSPTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:19:08 -0400
Received: from xenotime.net ([66.160.160.81]:46048 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754145AbYHSPTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:19:05 -0400
Date: Tue, 19 Aug 2008 08:19:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Aivils Stoss <aivils@latnet.lv>, stern@rowland.harvard.edu
Cc: lud <linux-usb@vger.kernel.org>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-input@vger.kernel.org, jkosina@suse.cz,
       linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
Message-Id: <20080819081936.37fef673.rdunlap@xenotime.net>
In-Reply-To: <200808191527.06945.aivils@latnet.lv>
References: <200808080702.24969.aivils@latnet.lv>
	<200808181642.49489.aivils@latnet.lv>
	<20080818081432.782d9632.rdunlap@xenotime.net>
	<200808191527.06945.aivils@latnet.lv>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 15:27:06 +0530 Aivils Stoss wrote:

> On Monday 18 August 2008 8:44:32 pm Randy Dunlap wrote:
> > On Mon, 18 Aug 2008 16:42:49 +0530 Aivils Stoss wrote:
> > > On Friday 15 August 2008 7:19:48 am Randy Dunlap wrote:
> > > > On Sun, 10 Aug 2008 04:08:37 +0100 Aivils Stoss wrote:
> > > > > On Saturday 09 August 2008 11:42:26 am Samuel Thibault wrote:
> > > > > > Aivils Stoss, le Fri 08 Aug 2008 07:02:24 +0100, a écrit :
> > > > > > > I suppose this is Linux kernel bug because i test keyboards under
> > > > > > > Windows, which support any schema of cascading of usb hubs.
> > > > > >
> > > > > > On the very same machine and hubs?
> > > > >
> > > > > Yes, on same machine. Under Windows i don't have evdev interface,
> > > > > checked only how keypress go to console.
> > > > > Of course to repeat a try You must have at least 5 keyboards and
> > > > > 1 7-port or 2 4-port hubs and kernel 2.6.22 and above. I allways
> > > > > got result - 5th, 6th, 7th keyboard does not send events to console
> > > > > or evdev.
> > > >
> > > > [adding linux-usb mailing list]
> > > >
> > > > Hi,
> > > >
> > > > I finally got 5 USB keyboards together along with 2 hubs.
> > > > I daisy-chained the hubs and connected 1 keyboard to the hub that is
> > > > on the notebook computer USB port, then I connected 4 keyboards to the
> > > > second hub.  They all worked for me, meaning that I can type on all of
> > > > them and have their characters show up on my console.
> > > >
> > > > I'm testing with 2.6.7-rc2.
> > > > 'usbtree' output of the USB subsystem is attached.
> > >
> > > Yeah! 2.6.7 is a bit obsolete. At my end 2.6.15 support more than 4
> > > keyboards per PC port , but mess up input when is plugged more than
> > > 9 keyboards. 10th is capable to send keypress events, but last pressed
> > > key will be repeated until ctrl-c . 10th keyboard disturb an auto repeat
> > > of all keyboards.
> >
> > Sorry, my keyboard made a typo.  I'm testing with 2.6.27-rc2.
> >
> > So the problem is now different from your original report, right?
> 
> No problem is same. Older kernels have another troubles.
> 2.6.22-1-mepis-smp
> Quite stable. Have oops sometime inside evdev. Support up to 16 
> USB keyboards, where 4 hubs are plugged into PC and 4 keyboards on
> each hub. Any hub cascade support only 4 keyboards, where 5th or more
> is registered but don't send input events. Oops inside evdev , when
> USB keyboard unplugged. No slow down even all USB keyboards does
> not work properly. My be this one support more than 16 keyboards, but
> i don't have PC USB ports enough.

Has the evdev oops been reported and/or fixed?
I think that we would prefer to fix that soonish.


> 2.6.24-7
> 4 keyboards per port. If plug in 5th tend to total slow down with this one:
> usb 2-1.1.1: reset low speed USB device using 
> uhci_hcd and address 17
> 5th - means 5th keyboard in USB hub's cascade, which is plugged into
> single PC USB port.
> 
> 2.6.26
> 4 keyboards per port. If plug in 5th tend to total slow down.
> 
> 2.6.27-rc3
> Sorry Randy i cannot repeat Your achievement. This worse of all tested
> kernels. I got working 3 USB keyboards, when i plug in 4th, all keyboards,
> include PS/2 stop working. Kernel does not hung up. I can reach box
> via net. dmesg , /proc/bus/input/devices attached. lsusb hung up.

Please try to include full dmesg (kernel boot log) in the future.
This was was truncated at the front (early messages).

> Please notify me , if i should use 2.6.27-rc2 !

It doesn't seem preferable for you yet.

Looks like it could be a problem just to put N low-speed devices on one root hub/port:

uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
etc etc.

Alan (Stern), could you look at this one, please?


> Aivils
> 
> >
> >
> > What speed is the host port that the keyboards are connected to?
> > Could it be a USB bus bandwidth limitation?  (not that any code
> > checks for that)
> >
> > I barely found 5 USB keyboards, so I surely can't test 10 or more.  ;)
> > I suppose that it will take some USB debug messages to attempt to see
> > what is going on...


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
