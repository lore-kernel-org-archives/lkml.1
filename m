Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0BXCdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:33:55 -0500
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:53400 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426Ab0BXCdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:33:53 -0500
X-Spam-Flag: NO
X-Spam-Score: 0
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Wed, 24 Feb 2010 04:33:48 +0200
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-0.rc8.1mnb; KDE/4.4.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Oliver Neukum <oliver@neukum.org>,
       dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002221510570.1328-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002221510570.1328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002240433.49116.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On maanantai 22 helmikuu 2010 22:12:41 Alan Stern wrote:
> On Mon, 22 Feb 2010, Matthew Garrett wrote:
> > On Mon, Feb 22, 2010 at 02:10:33PM -0500, Alan Stern wrote:
> > > On Mon, 22 Feb 2010, Anssi Hannula wrote:
> > > > Does this mean a tty interface is ill-suited for the microcode
> > > > upload, and instead qcserial should use the kernel's generic
> > > > microcode upload mechanism or the userspace should use libusb to do
> > > > it?
> > > 
> > > I don't know.  Didn't the old successful code use a tty interface?
> > 
> > Yes. The kfifo changes have caused some sort of alteration in behaviour.
> > 
> > > > Any idea what could be causing the hang, then?
> > > 
> > > No idea, unless it's the device.
> > 
> > Once the device hangs, it then tends to refuse any input until power
> > cycled. So it's clearly getting into some sort of undefined state,
> > though whether that's because it only gets sent half of its firmware
> > (ie, the hang occurs and as a result the hardware dies) or whether it's
> > causing the hang by dying is unclear.
> 
> The latest logs did show all the firmware getting sent -- or at least,
> they show that as much data was sent by the nonworking driver as by the
> working driver.  So I'd say the device causes the hang by dying,
> although I don't know where the hang is or why a dead device should
> cause it.

When the hang happens, the complete firmware is *not* sent to the device. The 
usbmon log is 10 times smaller:
http://stuff.onse.fi/gobi2000/gobi-regression2.mon.log
For reference, here's the hang with usbserial debug=1:
http://stuff.onse.fi/gobi2000/gobi-regression2.dmesg.log

The later logs were of runs that did not hang, but did still not work. I added 
descriptions here, in case someone is confused with all the logs (which I 
should've named better): http://stuff.onse.fi/gobi2000/

But if a device in corrupt state can cause such a hang, then it is likely that 
that is happening here (due to the packet bounding issue described in the 
other messages).

-- 
Anssi Hannula
