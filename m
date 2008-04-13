Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYDMUZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYDMUZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYDMUZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:25:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:55401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYDMUZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WvM7821bB0W7OOqX5VKrdJGai6A8Srd04+7yOdFIJMJNIn9cCZ17SjYmAOC9eK3tn4XM2tI1yOc/gNdwD4o+Pp0sVV8wYfjvL1+3GDcm64/MWNd6yiTZB6Q1xRRJrWvvq82w9kiSdnnN0q/g6WXAd0MtcMj7+B1bOGAH9Q2+5nA=
From: Alexia Death <alexiadeath@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problem: non-SDHC 2GB SD cards are unreadable
Date: Sun, 13 Apr 2008 23:26:07 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804132326.07713.alexiadeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. 

Ive come across a very annoying problem with these cards and the fat 
filesystem driver.

I recently bought 2 2GB Silicon Power SD cards for my camera(they were the 
smallest available in the store and had reasonable price). Camera was quite 
happy with them but I ran unexpectedly into trouble when trying to put the 
images to my Linux PC. 

It failed to read the cards and seemed to assume that my 2GB cards are 
actually 4GB O_o. I put one card back in to the camera and it was fine. I put 
the card in my photobank and it had no problem coping the images to its 
internal disk. 

Well, that was lame. Simple dumb devices can read the cards but not Linux. So 
I looked into dmesg to see whats up.

Heres what I saw:

[1193601.137141] sd 2:0:0:0: [sdb] Attached SCSI disk
[1193601.137256] sd 2:0:0:0: Attached scsi generic sg2 type 0
[1193601.156992] sd 2:0:0:1: [sdc] Attached SCSI removable disk
[1193601.157115] sd 2:0:0:1: Attached scsi generic sg3 type 0
[1193601.198450] sd 2:0:0:2: [sdd] 1992704 1024-byte hardware sectors (2041 
MB)
[1193601.206767] sd 2:0:0:2: [sdd] Write Protect is off
[1193601.206785] sd 2:0:0:2: [sdd] Mode Sense: 03 00 00 00
[1193601.206793] sd 2:0:0:2: [sdd] Assuming drive cache: write through
[1193601.227218] sd 2:0:0:2: [sdd] 1992704 1024-byte hardware sectors (2041 
MB)
[1193601.236730] sd 2:0:0:2: [sdd] Write Protect is off
[1193601.236745] sd 2:0:0:2: [sdd] Mode Sense: 03 00 00 00
[1193601.236752] sd 2:0:0:2: [sdd] Assuming drive cache: write through
[1193601.236768]  sdd: sdd1
[1193601.248543]  sdd: p1 exceeds device capacity
[1193601.248740] sd 2:0:0:2: [sdd] Attached SCSI removable disk
[1193601.248853] sd 2:0:0:2: Attached scsi generic sg4 type 0
[1193601.258517] sd 2:0:0:3: [sde] Attached SCSI removable disk
[1193601.258639] sd 2:0:0:3: Attached scsi generic sg5 type 0
[1193602.633223] attempt to access beyond end of device
[1193602.633239] sdd: rw=0, want=7970672, limit=3985408
[1193602.633248] Buffer I/O error on device sdd1, logical block 3985088
[1193602.633260] attempt to access beyond end of device
[1193602.633266] sdd: rw=0, want=7970674, limit=3985408
[1193602.633272] Buffer I/O error on device sdd1, logical block 3985089

,,, and so on.

Trying to mount it results in:
[1194411.241063] FAT: logical sector size too small for device (logical sector 
size = 512)

As I understand the above, my cards report hardware sector size 1024-bytes and 
FAT logical block size of 512 but the FAT driver insists on using the 
hardware block size over the logical one... witch obviously results in 
failure.

http://en.wikipedia.org/wiki/Secure_Digital_card#Compatibility_issues_with_2_GB_and_larger_cards
tells me that this is the result of a hack due to the nature of 2GB cards.

Are there any plans to make 2GB SD cards work? I doubt I'm the only one with 
such 2GB SD cards(and a camera) and Id be royally screwed right about now if 
I did not have my photobank and an option to use it as a copy over point...

--
Best, Alexia

PS. Please CC me, I am not subscribed... 
