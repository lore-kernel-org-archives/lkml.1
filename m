Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYFSUsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYFSUsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYFSUsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:48:36 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:33412 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYFSUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:48:35 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote Control
References: <871w2xnehf.fsf@old-tantale.fifi.org>
	<Pine.LNX.4.64.0806181139490.10085@jikos.suse.cz>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 19 Jun 2008 13:48:29 -0700
In-Reply-To: <Pine.LNX.4.64.0806181139490.10085@jikos.suse.cz>
Message-ID: <87bq1xgnhe.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> Please compile your kernel with 'CONFIG_HID_DEBUG', modprobe the 'hid' 
> module with 'debug=2' parameter, and send me the output that appears is 
> dmesg output when you press the non-working keys.

debug=2 didn't work.  dmesg said:

  hid: `2' invalid for parameter debug.

With debug=1, I get the following output.

But first, info:

kernel 2.6.25.6 - no extra patches

/proc/bus/usb/devices

T:  Bus=05 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0c16 ProdID=0002 Rev= 2.20
S:  Manufacturer=Gyration
S:  Product=Gyration RF Technology Receiver
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr= 98mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms

There are 6 six keys which do not work at all:

 * "MCE Home key - green button"

First time pressed:

drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  00 00

Second and subsequent times pressed:

drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  0d 00
hid-debug: input ffbc.000d = 1
drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  00 00
hid-debug: input ffbc.000d = 0

 * "Pictures" shortcut button

drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  49 00
hid-debug: input ffbc.0049 = 1
drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  00 00
hid-debug: input ffbc.0049 = 0

 * "TV" shortcut button

drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  46 00
hid-debug: input ffbc.0046 = 1
drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  00 00
hid-debug: input ffbc.0046 = 0

 * "Music" shortcut button

drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  47 00
hid-debug: input ffbc.0047 = 1
drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  00 00
hid-debug: input ffbc.0047 = 0

 * "Movies" shortcut button

drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  4a 00
hid-debug: input ffbc.004a = 1
drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  00 00
hid-debug: input ffbc.004a = 0

 * "Live TV" button

drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  25 00
hid-debug: input ffbc.0025 = 1
drivers/hid/hid-core.c: report (size 3) (numbered)
drivers/hid/hid-core.c: report 6 (size 2) =  00 00
hid-debug: input ffbc.0025 = 0


Also, the "Power" button keeps repeating once pressed:

drivers/hid/hid-core.c: report (size 2) (numbered)
drivers/hid/hid-core.c: report 3 (size 1) =  82
hid-debug: input GenericDesktop.SystemPowerDown = 0
hid-debug: input GenericDesktop.SystemSleep = 1
hid-debug: input GenericDesktop.SystemWakeUp = 0


There you are.
Let me know if there is anything else I can do.

Phil.
