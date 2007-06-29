Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbXF2IWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbXF2IWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXF2IW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:22:27 -0400
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15458 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbXF2IW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:22:26 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Clemens Koller <clemens.koller@anagramm.de>
Subject: Re: 2.6.21.5: BUG: usbtouchscreen.c DMC TSC-10 wrong descriptor type / type->init() failed.
Date: Fri, 29 Jun 2007 10:22:16 +0200
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       daniel.ritz@gmx.ch
References: <468294E4.40801@anagramm.de> <d120d5000706271004u5e2304dekd4ad5315cdd4a55@mail.gmail.com> <4683D444.5030408@anagramm.de>
In-Reply-To: <4683D444.5030408@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291022.16888.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The same is true if there is no EEPROM present but the EEPROM
> is enabled. Anyway, I disabled my EEPROM by pulling the SEL4
> pin high because I don't need/want it (yet).

The same is done by my hardware guy. In my case, there is no 
EEPROM attached ... but he didn't pull up this pin up, until I 
found out what happend.

For the EEPROM: I actually don't care if the calibration data is 
written somewhere in my filesystem or in some proprietary 
EEPROM. If you create gadgets with unwritable filesystems, e.g. 
cramfs, then you might care. But I didn't, and therefore didn't 
bother implementing any support for calibration on the 
driver-level. I'm doing that completely from userspace.



> I started to do some more error handling, but it's propably
> not worth doing so if the driver(s) has only limited
> functionality (and no userspace app using it).

Who says that the driver has no user space app?  All touchscreen 
events that you get are exported via /dev/input/eventX to user 
space and there are plenty of apps that utilize this info.

I wrote a (company inside) tool that reads /dev/input/eventXX, 
calibrates them and injects those events into X11 via the XTest 
extension. But for newer X.Org release you can also use 
xserver-input-event driver. My approach has just the benefit 
that I can "SIGHUP" my driver any time to re-calibrate, I don't 
need to restart X for this, which is cumbersome.


So, please add error handling and post your patch :-)
