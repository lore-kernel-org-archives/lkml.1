Return-Path: <linux-kernel-owner+w=401wt.eu-S1765190AbYCDRWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765190AbYCDRWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764862AbYCDRWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:22:18 -0500
Received: from sd-green-dreamhost-133.dreamhost.com ([208.97.187.133]:38338
	"EHLO webmail1.sd.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763722AbYCDRWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:22:17 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 12:22:17 EST
Message-ID: <26349.208.97.187.133.1204650893.squirrel@mail.losgandia.com>
Date: Tue, 4 Mar 2008 09:14:53 -0800 (PST)
Subject: PROBLEM: NUDAM (USB-485) nowaday not detected by pl2303 module
From: rafa400@losgandia.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] new NUDAM (USB-485) converter not recogniced by pl2303. Little change
required.
[2.] Until now NUDAM USB to RS-485/422 RS232 converter was detected by USB
system and pl2303 module working fine in my Debian as /dev/ttyUSB0

# dmesg
....
usb 5-1.3: new full speed USB device using ehci_hcd and address 17
usb 5-1.3: configuration #1 chosen from 1 choice
pl2303 5-1.3:1.0: pl2303 converter detected
usb 5-1.3: pl2303 converter now attached to ttyUSB0

# lsusb
Bus 005 Device 017: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port

 They changed USB ID and now its like:

# lsusb
Bus 005 Device 016: ID 0b63:6530 ADLink Technology, Inc.

but this ID is not detected by PD2303 module.
a little change in pl2303 solve the problem

[3.] pl2303 NUDAM USB 485
[4.] Linux version 2.6.24-nudam (2.6.24-4) (root@rp022) (gcc version 4.2.3
20080114 (prerelease) (Debian 4.2.2-7)) #1 SMP Mon Mar 3 12:02:41 CET 2008
[5.] not required
[6.] not required
[7.] not required
[X.] Other notes, patches, fixes, workarounds:
I made the tribial changes in:

drivers/usb/serial/pl2303.c
drivers/usb/serial/pl2303.h

adding de new USB ID 0b63:6530 to the existing arrays as needed
recompile kernel, etc,etc.
and it works fine again.

Please include this in newer versions if it is possible.

Rafael Gandia-Castello

