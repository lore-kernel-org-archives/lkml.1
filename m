Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYAHBU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYAHBU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 20:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbYAHBUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 20:20:16 -0500
Received: from bossdog.realss.com ([211.157.108.128]:53581 "EHLO
	bossdog.realss.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYAHBUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 20:20:14 -0500
X-Greylist: delayed 1263 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2008 20:20:14 EST
Subject: Huawei EC321 CDMA PCCARD support broken
From: =?UTF-8?Q?=E5=BC=A0=E9=9F=A1=E6=AD=A6?= <zhangweiwu@realss.com>
To: linux-kernel@vger.kernel.org
Cc: smurf@smurf.noris.de, hugh@blemings.org
X-Identity-Key: id1
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; uuencode=0
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain
Organization: Real Softservice
Date: Tue, 08 Jan 2008 08:58:51 +0800
Message-Id: <1199753931.6093.7.camel@Cruella>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all

A lot of google searches reflect that, the latest kernel supporting
Huawei EC321 CDMA PCCARD is 2.6.17. My version (2.6.22-14 on Ubuntu)
doesn't work.

I am not sure if I should file a bug somewhere or how to contact the
right person. I see another version of this card (Huawei E220) was
discussed on this list and so I though this is the right place to post
this information. Redirect me to someone else if I posted in wrong
place, thank you. 

I can give away my card to someone if they can use it to modify driver
to add the support back. I can also type some commands and get you the
result if you ask me to. What I cannot is describe it technically good
enough to show the problem without other's prompt/help. I also cannot
debug program or read source code.

I need to emphasize this is a very common model card in China mainland,
it's the "default" one, many of my friends has it. So it make sense to
get the support back.

dmesg on 2.6.22-14 (that doesn't work):
[ 3802.596000] usb 7-1: new full speed USB device using ohci_hcd and
address 2
[ 3803.756000] usb 7-1: new full speed USB device using ohci_hcd and
address 4
[ 3804.024000] usb 7-1: configuration #1 chosen from 1 choice
[ 3804.132000] usbcore: registered new interface driver usbserial
[ 3804.132000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[ 3804.132000] usbcore: registered new interface driver
usbserial_generic
[ 3804.132000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/usb-serial.c: USB Serial Driver core
[ 3804.140000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
[ 3804.140000] pl2303 7-1:1.0: pl2303 converter detected
[ 3804.140000] usb 7-1: pl2303 converter now attached to ttyUSB0
[ 3804.140000] pl2303 7-1:1.1: pl2303 converter detected
[ 3804.140000] usb 7-1: pl2303 converter now attached to ttyUSB1
[ 3804.140000] usbcore: registered new interface driver pl2303
[ 3804.140000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
[ 3804.148000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/usb-serial.c: USB Serial support registered for GSM modem (1-port)
[ 3804.148000] usbcore: registered new interface driver option
[ 3804.148000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/option.c: USB Driver for GSM modems: v0.7.1

this is how it doesn't work:

pango@Cruella:~$ sudo wvdial
WvDial<*1>: WvDial: Internet dialer version 1.56
WvModem<*1>: Cannot get information for serial port.
WvDial<*1>: Initializing modem.
WvDial<*1>: Sending: ATZ
WvDial Modem<*1>: ATZ
WvDial Modem<*1>: OK
WvDial<*1>: Sending: ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
WvDial Modem<*1>: ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
WvDial Modem<*1>: OK
WvDial<*1>: Modem initialized.
WvDial<*1>: Sending: ATDT#777
WvDial<*1>: Waiting for carrier.
WvDial Modem<*1>: ATDT#777
WvDial Modem<*1>: CONNECT 230400
WvDial<*1>: Carrier detected.  Waiting for prompt.
WvDial<Err>: Connected, but carrier signal lost!  Retrying...
WvDial<*1>: Sending: ATDT#777
WvDial<*1>: Waiting for carrier.
WvDial Modem<*1>: ATDT#777
WvDial Modem<*1>: CONNECT 230400
WvDial<*1>: Carrier detected.  Waiting for prompt.
[above repeats...]

dmesg on 2.6.15-23:
$ dmesg
...
[4294705.381000] drivers/usb/serial/usb-serial.c: USB Serial support registered for Option 3G data card
[4294705.382000] option 2-1:1.0: Option 3G data card converter detected
[4294705.382000] usb 2-1: Option 3G data card converter now attached to ttyUSB0
[4294705.382000] option 2-1:1.1: Option 3G data card converter detected
[4294705.383000] usb 2-1: Option 3G data card converter now attached to ttyUSB1
[4294705.383000] usbcore: registered new driver option
[4294705.383000] drivers/usb/serial/option.c: Option Card (PC-Card to) USB to Serial Driver: v0.4

Some other users on the Internet says this is because the device is
mis-recognized (should be 3G data card but mis-recognized as GSM modem.
I am not sure if this is the case, because I could not find the phase
"3G data card" in drivers/usb/serial/option.c in  2.6.22-14 kernel, this
phrase existed in 2.6.17 in option.c

For your information, EC321 is a CDMA card, in sales people's words,
it's way too different from GSM. I am dumb on this anyway.

Best regards.
-- 
Real Softservice

Huateng Tower, Unit 1788
Jia 302 3rd area of Jinsong, Chao Yang

Tel: +86 (10) 8773 0650 ext 603
Mobile: 135 9950 2413
http://www.realss.com

