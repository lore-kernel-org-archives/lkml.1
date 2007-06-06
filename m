Return-Path: <linux-kernel-owner+w=401wt.eu-S935795AbXFFVp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935795AbXFFVp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933487AbXFFVpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:45:21 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:43930 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbXFFVpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:45:20 -0400
X-Greylist: delayed 1471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 17:45:20 EDT
Date: Wed, 6 Jun 2007 23:20:46 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-kernel@vger.kernel.org
Subject: USB low-speed bulk transfers
Message-ID: <20070606212046.GA16162@uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux 2.6.20.4 on a x86_64
X-Message-Flag: Outlook? --> http://www.mozilla.org/products/thunderbird/
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Please Cc on reply]

Hi,

I recently bought an USB MIDI interface from ESI (called “ESI MIDI Mate”). It
claims to work with Linux, but doesn't -- I've already asked the manufacturer
for an explanation, but as I was impatient, I hacked a bit on the drivers to
actually make it work...

The /proc/bus/usb/devices entry looks like this:

  T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=1.5 MxCh= 0
  D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
  P:  Vendor=0a92 ProdID=1001 Rev= 1.04
  S:  Manufacturer=ESI
  S:  Product=ESI MIDI Mate
  C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr= 20mA
  I:* If#= 0 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=00 Driver=snd-usb-audio
  I:* If#= 1 Alt= 0 #EPs= 2 Cls=01(audio) Sub=03 Prot=00 Driver=snd-usb-audio
  E:  Ad=81(I) Atr=02(Bulk) MxPS=   4 Ivl=0ms
  E:  Ad=01(O) Atr=02(Bulk) MxPS=   4 Ivl=0ms

There are two points worth noting here:

 - The device is USB low speed. snd-usb-audio simply checks for full/high
   speed, and refuses any device that isn't. I can hack around this,
   inverting a few checks etc., and it seems to work reasonably well
   (probably since the device has no PCM parts).
 - Both endpoint descriptors are bulk. The HCD driver plain refuses bulk
   transfers for low-speed; it looks like they are disallowed in the USB
   standard somehow. If I comment out the check, the driver works
   (perfectly!), but I guess this isn't acceptable for upstream?

Could the check for low-speed bulk transfers be replaced by a kernel warning
somehow? I can't see any big harm by allowing them, and obviously, Windows XP
and Mac OS X does so.

I can supply a patch for the snd-usb-audio specific parts if desired, but I
can't guarantee it's the correct fix for cards that support PCM. Not that I
know of any PCM-capable low-speed USB sound cards out there...

/* Steinar */
-- 
Homepage: http://www.sesse.net/
