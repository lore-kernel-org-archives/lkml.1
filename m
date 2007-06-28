Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbXF1Pbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbXF1Pbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbXF1PbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:31:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbXF1PbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:31:23 -0400
Message-ID: <4683D444.5030408@anagramm.de>
Date: Thu, 28 Jun 2007 17:31:16 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, daniel.ritz@gmx.ch,
       hs4233@mail.mn-solutions.de
Subject: Re: 2.6.21.5: BUG: usbtouchscreen.c DMC TSC-10 wrong descriptor type
 / type->init() failed.
References: <468294E4.40801@anagramm.de> <d120d5000706271004u5e2304dekd4ad5315cdd4a55@mail.gmail.com>
In-Reply-To: <d120d5000706271004u5e2304dekd4ad5315cdd4a55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18wz7lGwycalSkx/IWpSadvUKY4mwKMcUSH4G/
 3uTGJ8B1r5elKZ2m3mELbN5FuZ/8rxoY8ifhdTrLWNk7ihtOOH
 noZdqvhQNIPmEWIc1gdZQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dimitry!

Dmitry Torokhov schrieb:
> Hi,
> 
> On 6/27/07, Clemens Koller <clemens.koller@anagramm.de> wrote:
>> drivers/usb/input/usbtouchscreen.c: usbtouch_probe - type->init() 
>> failed, err: -19
> 
> dmc_tsc10_init() returns -ENODEV (-19) when device responds with
> something other than 0x06 0x00 to the "reset" and "set rate" commands.
> It would be interesting to see what your touchscreen responses are.

I found the problem:
After the reset, I got a 0x06 0x00 back, which is fine.

But when the driver sets the coordinate output rate, the TSC-103
answered 0x15 0x01 which means that the TSC-10 is used with an
EEPROM but the EEPROM data is empty (which is correct).

In that case the driver should at least continue to allow
initialization of the EEPROM later on. But as we don't have the
infrastructure to write the calibration data back to EEPROM, only
touch screen manufacturers which want to use the EEPROM will run into
that problem...

The same is true if there is no EEPROM present but the EEPROM is enabled.
Anyway, I disabled my EEPROM by pulling the SEL4 pin high because I don't
need/want it (yet).

So, it *works for me* but just for future reference:
The DMC TSC-10 driver doesn't start, when it has an empty (new)
EEPROM attached.

I started to do some more error handling, but it's propably not
worth doing so if the driver(s) has only limited functionality (and
no userspace app using it).

Thank you,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
