Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYBENX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYBENX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYBENXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:23:47 -0500
Received: from mail.ku-gbr.de ([81.3.11.18]:47857 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751635AbYBENXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:23:46 -0500
X-Greylist: delayed 2401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 08:23:46 EST
Date: Tue, 5 Feb 2008 13:43:43 +0100
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: [Patch 1/1] Nikon D80 usb-storage quirk needs modified, new FW
Message-ID: <20080205124343.GB6638@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nikon did update their FW for the Nikon D80 and usb-storage got
unusable:

scsi 10:0:0:0: Direct-Access     NIKON    D80              1.10 PQ: 0 ANSI: 2
sd 10:0:0:0: [sdb] 3970049 512-byte hardware sectors (2033 MB)
sd 10:0:0:0: [sdb] Write Protect is off
sd 10:0:0:0: [sdb] Mode Sense: 0f 00 00 00
sd 10:0:0:0: [sdb] Assuming drive cache: write through
sd 10:0:0:0: [sdb] 3970049 512-byte hardware sectors (2033 MB)
sd 10:0:0:0: [sdb] Write Protect is off
sd 10:0:0:0: [sdb] Mode Sense: 0f 00 00 00
sd 10:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 10:0:0:0: [sdb] Attached SCSI removable disk
sd 10:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
end_request: I/O error, dev sdb, sector 3970048
printk: 56 messages suppressed.
Buffer I/O error on device sdb, logical block 3970048
end_request: I/O error, dev sdb, sector 3970048

or with another SDCARD:

scsi 8:0:0:0: Direct-Access     NIKON    D80              1.10 PQ: 0 ANSI: 2
sd 8:0:0:0: [sdb] 3970049 512-byte hardware sectors (2033 MB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 0f 00 00 00
sd 8:0:0:0: [sdb] Assuming drive cache: write through
sd 8:0:0:0: [sdb] 3970049 512-byte hardware sectors (2033 MB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 0f 00 00 00
sd 8:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 8:0:0:0: [sdb] Attached SCSI removable disk
sd 8:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
usb 4-2: reset high speed USB device using ehci_hcd and address 7
usb 4-2: reset high speed USB device using ehci_hcd and address 7
end_request: I/O error, dev sdb, sector 3970048
printk: 51 messages suppressed.
Buffer I/O error on device sdb, logical block 3970048
end_request: I/O error, dev sdb, sector 3970048
Buffer I/O error on device sdb, logical block 3970048
end_request: I/O error, dev sdb, sector 3970048
Buffer I/O error on device sdb, logical block 3970048
end_request: I/O error, dev sdb, sector 3970048
Buffer I/O error on device sdb, logical block 3970048
end_request: I/O error, dev sdb, sector 3970048
Buffer I/O error on device sdb, logical block 3970048
usb 4-2: reset high speed USB device using ehci_hcd and address 7
usb 4-2: reset high speed USB device using ehci_hcd and address 7
usb 4-2: reset high speed USB device using ehci_hcd and address 7
usb 4-2: reset high speed USB device using ehci_hcd and address 7
usb 4-2: can't restore configuration #1 (error=-71)
usb 4-2: USB disconnect, address 7
sd 8:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 3969985
Buffer I/O error on device sdb, logical block 3969985
sd 8:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 3970032
sd 8:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 3970048
sd 8:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 3970048
sd 8:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 40

I relized the unusal_devs.h needs to be adapted to 
reflect new FW Version, then it works fine again:

--- linux-2.6.23/drivers/usb/storage/unusual_devs.h_orig        2008-02-05 13:33:55.010623616 +0100
+++ linux-2.6.23/drivers/usb/storage/unusual_devs.h     2008-02-05 13:32:22.926623601 +0100
@@ -342,7 +342,7 @@
                US_FL_FIX_CAPACITY),

 /* Reported by Emil Larsson <emil@swip.net> */
-UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0101,
+UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
                "NIKON",
                "NIKON DSC D80",
                US_SC_DEVICE, US_PR_DEVICE, NULL,


What I wonder is, why are there other examples only reflecting the
newest Firmware, are older ones also catched?





Kind Regards, Konsti




-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
