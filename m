Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbYDVXPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbYDVXPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYDVXPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:15:09 -0400
Received: from vwp1316.webpack.hosteurope.de ([87.230.105.72]:57075 "EHLO
	vwp1316.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYDVXPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:15:06 -0400
Date: Wed, 23 Apr 2008 01:14:59 +0200
From: speedy <speedy@3d-io.com>
X-Mailer: The Bat! (v4.0.18) Home
Reply-To: speedy <speedy@3d-io.com>
X-Priority: 3 (Normal)
Message-ID: <396712385.20080423011459@3d-io.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG REPORT, 2.6.22] sata controler failure on nforce 2 chipset
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-bounce-key: webpack.hosteurope.de;speedy@3d-io.com;1208906106;e41c847e;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linux kernel crew,

       [Consider this more as a datapoint then a bug report, as after
       one network and one sata/southbridge issues showing up
       interminnently, the ASRock motherboard involved will be
       scrapped for a different one]

       The integrated NVidia sata controller and/or the hard-drive has failed
       during operation with the following output:

Apr 22 23:36:54 backupserver kernel: [91202.294632]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Apr 22 23:36:59 backupserver kernel: [91207.657630] ata2: port is slow to respond, please be patient (Status 0xd0)
Apr 22 23:37:04 backupserver kernel: [91212.331576] ata2: device not ready (errno=-16), forcing hardreset
Apr 22 23:37:04 backupserver kernel: [91212.331583] ata2: hard resetting port
Apr 22 23:37:09 backupserver kernel: [91217.874396] ata2: port is slow to respond, please be patient (Status 0x80)
Apr 22 23:37:14 backupserver kernel: [91222.368598] ata2: hard resetting port
Apr 22 23:37:19 backupserver kernel: [91227.911395] ata2: port is slow to respond, please be patient (Status 0x80)
Apr 22 23:37:24 backupserver kernel: [91232.405597] ata2: hard resetting port
Apr 22 23:37:29 backupserver kernel: [91237.948395] ata2: port is slow to respond, please be patient (Status 0x80)
Apr 22 23:37:59 backupserver kernel: [91267.370311] ata2: hard resetting port
Apr 22 23:38:04 backupserver kernel: [91272.373843] ata2.00: disabled
Apr 22 23:38:04 backupserver kernel: [91272.373858] ata2: EH complete
Apr 22 23:38:04 backupserver kernel: [91272.374653] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Apr 22 23:38:04 backupserver kernel: [91272.374659] end_request: I/O error, dev sdb, sector 35277535
Apr 22 23:38:04 backupserver kernel: [91272.374682] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374706] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374726] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374745] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374765] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374785] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374805] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374825] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374844] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.374864] lost page write due to I/O error on md0
Apr 22 23:38:04 backupserver kernel: [91272.375058] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Apr 22 23:38:04 backupserver kernel: [91272.375062] end_request: I/O error, dev sdb, sector 35278559
Apr 22 23:38:04 backupserver kernel: [91272.375096] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Apr 22 23:38:04 backupserver kernel: [91272.375099] end_request: I/O error, dev sdb, sector 407240943
.
.
.

       Full /var/log/messages can be found on: http://87.230.23.147/messages_sata_crash.txt

       The two 500GB Samsung HD501LJ hard-drives were making resetting
       sounds in regular intervals, trying to recover from the error,
       unsucessfuly. The system was accessed via network/SSH and was
       shutdown "gracefully" via shutdown -h now.

       After restarting, the system seemingly continued to operate
       normaly without any apparent data loss.

       One thing of note is that the south-bridge was alarmingly hot
       to the touch (you could "burn your finger" on it) so I would
       attribute the problems to improper cooling of hardware.
       Previously the system had uptimes of 100+ days as a render farm
       master using Windows 2000 (mostly CPU/memory load, though).

       I won't be able to test the same system further as it's
       motherboard will be (promptly:p) exchanged.

       ps. Keep me in CC:, not following the list.


-- 
Best regards,
 speedy                          mailto:speedy@3d-io.com

