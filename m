Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0CCEwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 23:52:17 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:4979 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717Ab0CCEwQ (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Tue, 2 Mar 2010 23:52:16 -0500
Message-Id: <4B8E85AC020000230001413A@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 02 Mar 2010 21:52:12 -0700
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <mzxreary@0pointer.de>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that
	 is need load SCM
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, 

First, thank's for your kindly review and suggestion to me.

於 二，2010-03-02 於 15:46 -0800，Greg KH 提到：
> On Tue, Mar 02, 2010 at 11:39:29PM +0000, Matthew Garrett wrote:
> > On Tue, Mar 02, 2010 at 03:28:57PM -0800, Greg Kroah-Hartman wrote:
> > > From: Lee, Chun-Yi <jlee@novell.com>
> > > 
> > > Some MSI 3G netbook only have one fn key to control Wlan/Bluetooth/3G,
> > > those netbook will load the SCM (windows app) to disable the original
> > > Wlan/Bluetooth control by BIOS when user press fn key, then control
> > > Wlan/Bluetooth/3G by SCM (software control by OS). Without SCM, user
> > > cann't on/off 3G module on those 3G netbook.
> > > On Linux, msi-laptop driver will do the same thing to disable the
> > > original BIOS control, then might need use HAL or other userland
> > > application to do the software control that simulate with SCM.
> > > e.g. MSI N034 netbook
> > 
> > How does the function key event get reported to userland? This should 
> > generate KEY_RFKILL and then just go through rfkill-input.

I developed this driver on 2.6.31 kernel, and I found this key code is
in 2.6.33 kernel and later.
There have one and only one scancode to control 3 devices when end user
press fn+f11 key on MSI N034.
Currently, we setup this mapping in HAL key and mapping it to KEY_WLAN.

Does that means I need mapping the scancode to KEY_RFKILL in msi-laptop
driver for 2.6.33 kernel?
If YES, I will submit another patch to add this scancode/keycode mapping
in msi-laptop.c

> I'm pretty sure that Joey is using rfkill here, but I didn't realize
> that it also supported an input device.
> 
> This code is just detecting the keypress, and acting on it, I think,
> right Joey?  Isn't that the way this is supposed to work?  Or is it
> supposed to use rfkill-input, which then userspace turns around and
> calls the other rfkill interface to then disable the wireless?  If so, I
> think a number of laptop drivers need to be changed to do this.
> 

There have a serial MSI netbook (like: N034) use only one scancode (one
function key) to control 3 devices (Wlan/Bluetooth/3G). It have a
sequence to control those device and userland application control this
sequence, almost like:
	- Bluetooth on, WLAN on, WWAN on
	- Bluetooth on, WLAN off, WWAN off
	- Bluetooth off, WLAN off, WWAN on
	....
	- Bluetooth off, WLAN off, WWAN off

Even on Windows platform, this job is also handle by userland
application, not by hardware or driver. And MSI EC provide a address to
turn on/off those devices' power and led light.

This patchset for msi-laptop driver is just to provide Wlan/Bluetooth/3G
rfkill sysfs interface for userland to turn on/off those devices's power
and led.
And this patchset doesn't do:
    - setup the wifi function key scancode/keycode mapping.
    - control those 3 devices on/off sequence. (userland control it)


Thank's
Joey Lee

