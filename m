Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZEYPN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZEYPN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZEYPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:13:19 -0400
Received: from smtpout2.uol.com.br ([200.221.4.193]:54312 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828AbZEYPNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:13:18 -0400
Date: Mon, 25 May 2009 12:13:14 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: [PATCH] usb-storage: include USB drive in unusual_devs list
Message-ID: <20090525151313.GA2246@ime.usp.br>
References: <20090524161114.GA2667@ime.usp.br> <Pine.LNX.4.44L0.0905242226570.15195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0905242226570.15195-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 6813f5e703704857a2f56bf5a8eb2f1a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, Alan.

And thank you very much for your valuable (and always enlightening) comments.

On May 24 2009, Alan Stern wrote:
> I see the problem.  It's a bug in the Prolific drive.  The drive says
> that it has removable media, which is not true.  Then when the computer
> tells the drive to lock the media in place, the drive reports an error.  
> And it doesn't use the proper error code, so the computer doesn't
> know what went wrong.

Hummm, that's bad. :-(

> You can test this by setting a "quirks" option for usb-storage, to tell 
> it that the Prolific drive does not understand the "Lock" command:
> 
> 	modprobe usb-storage quirks=67b:2316:L

Well, I did that, but it, unfortunately, didn't seem to work:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
chagas:~# dmesg | tail -n 45; cat /sys/module/usb_storage/parameters/quirks; lsusb
[ 2703.243277] Driver 'sd' needs updating - please use bus_type methods
[ 2703.243433] PM: Adding info for No Bus:0:0:0:0
[ 2703.249091] sd 0:0:0:0: [sda] 256000 512-byte hardware sectors: (131 MB/125 MiB)
[ 2703.252061] sd 0:0:0:0: [sda] Write Protect is off
[ 2703.252067] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[ 2703.252071] sd 0:0:0:0: [sda] Assuming drive cache: write through
[ 2703.252123] PM: Adding info for No Bus:sda
[ 2703.259056] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2703.259061]    : Sense Key : 0x0 [current] 
[ 2703.259067]    : ASC=0x0 ASCQ=0x0
[ 2703.267025] sd 0:0:0:0: [sda] Assuming drive cache: write through
[ 2703.267032]  sda: sda1
[ 2703.273099] PM: Adding info for No Bus:sda1
[ 2703.278056] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2703.278061]    : Sense Key : 0x0 [current] 
[ 2703.278067]    : ASC=0x0 ASCQ=0x0
[ 2703.278171] PM: Adding info for No Bus:8:0
[ 2703.278195] sd 0:0:0:0: [sda] Attached SCSI removable disk
[ 2703.300019] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2703.300026]    : Sense Key : 0x0 [current] 
[ 2703.300033]    : ASC=0x0 ASCQ=0x0
[ 2703.603961] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2703.603968]    : Sense Key : 0x0 [current] 
[ 2703.603974]    : ASC=0x0 ASCQ=0x0
[ 2703.671981] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2703.671988]    : Sense Key : 0x0 [current] 
[ 2703.671994]    : ASC=0x0 ASCQ=0x0
[ 2703.693975] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2703.693981]    : Sense Key : 0x0 [current] 
[ 2703.693987]    : ASC=0x0 ASCQ=0x0
[ 2703.703974] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2703.703981]    : Sense Key : 0x0 [current] 
[ 2703.703987]    : ASC=0x0 ASCQ=0x0
[ 2704.006895] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2704.006902]    : Sense Key : 0x0 [current] 
[ 2704.006908]    : ASC=0x0 ASCQ=0x0
[ 2704.016920] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2704.016927]    : Sense Key : 0x0 [current] 
[ 2704.016933]    : ASC=0x0 ASCQ=0x0
[ 2704.318865] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2704.318871]    : Sense Key : 0x0 [current] 
[ 2704.318878]    : ASC=0x0 ASCQ=0x0
[ 2704.366850] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[ 2704.366857]    : Sense Key : 0x0 [current] 
[ 2704.366863]    : ASC=0x0 ASCQ=0x0
67b:2316:L
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 004: ID 067b:2316 Prolific Technology, Inc. Flash Disk Security Device
Bus 004 Device 003: ID 067b:2317 Prolific Technology, Inc. Mass Storage Device
Bus 004 Device 002: ID 067b:2315 Prolific Technology, Inc. Flash Disk Embedded Hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
chagas:~#
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

> If that eliminates the errors, we can add a permanent quirk entry for 
> this device.

I can test whatever you want me to, so that this can be fixed. The above
lsusb log shows that, perhaps, the quirks option should be set for the
device 067b:2317, instead of 067b:2316, as you told me to?

(I'm going to verify it right now).

Yes, that works. Using 67b:2317:L as a quirk eliminates the messages.
And I do get the

[ 3454.054150] usb-storage 4-2.1:1.0: Quirks match for vid 067b pid 2317: 80

message. Therefore, a proposal:

This patch adds a quirk entry for the Leading Driver UD-11
usb flash drive.

As Alan Stern told me, the device doesn't deal correctly with
the locking media feature of the device, and this patch
incorporates it.

Compiled, tested, working.


Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

The US_PR_DEVICE macro could be changed to US_PR_CBI, from what
I saw in the udevadm info tree.

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -838,6 +838,19 @@ UNUSUAL_DEV( 0x066f, 0x8000, 0x0001, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Rogério Brito <rbrito@ime.usp.br> */
+/* 'lsusb' tells:
+ *    "Prolific Technology, Inc. Mass Storage Device"
+ * but 'udevadm info' says:
+ *    ATTR{manufacturer}=="Leading Driver Co.,LTD."
+ *    ATTR{product}=="USB Mass Storage Device"
+ */
+UNUSUAL_DEV( 0x067b, 0x2317, 0x0001, 0x001,
+		"Prolific Technology, Inc.",
+		"Mass Storage Device",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_NOT_LOCKABLE ),
+
 /* Reported by Richard -=[]=- <micro_flyer@hotmail.com> */
 /* Change to bcdDeviceMin (0x0100 to 0x0001) reported by
  * Thomas Bartosik <tbartdev@gmx-topmail.de> */


Actually, I just ventured myself and created a patch, attached (sorry, I
know that people don't like attached patches, but I don't want to mix


Thank you so much as always, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
