Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZJNHz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZJNHz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZJNHz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:55:56 -0400
Received: from mx2.univ-lille2.fr ([194.254.117.6]:47743 "EHLO
	smtp.univ-lille2.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZJNHzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:55:54 -0400
Message-ID: <4AD583DB.2070806@univ-lille2.fr>
Date: Wed, 14 Oct 2009 09:55:07 +0200
From: Christian Vilhelm <christian.vilhelm@univ-lille2.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: tfjellstrom@shaw.ca
CC: andy yan <andyysj@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>, kewei@marvell.com
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
References: <200910091141.52303.tfjellstrom@shaw.ca> <200910131939.09039.tfjellstrom@shaw.ca> <e938503f0910132151p20b42459v96800d889f3f63eb@mail.gmail.com> <200910140118.39988.tfjellstrom@shaw.ca>
In-Reply-To: <200910140118.39988.tfjellstrom@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Fjellstrom wrote:
> On Tue October 13 2009, andy yan wrote:
>> I will send you a patch for debugging this issue, please help to try and
>> send back the log, thanks!
> 
> I will do whatever I can to help get this resolved :) I have some C skills, 
> but no kernel/device driver experience, so at the very least I should be able 
> to do builds and make small changes if needed, in addition to patching and 
> endless reboots ;D

I'm also willing to help.
The card is not on a production server and the disks connected to the 
card do not contain any valuable data so I can make any test wanted.

When the problem occurs it seems the devices (disks) are hosed. Deleting 
them from the system (echo 1 > /sys/block/sdh/device/delete), removing 
the mvsas module (rmmod -f) and reloading it doesn't work. The card 
seems correctly initialised after reloading the module, it correctly 
responds to commands (in /sys/class/sas_phy/ and sas_ports, I can reset 
ports/phys, I can ask for a rescan of disks). But the disks themselves 
do not seem to answer to the scan and are not detected, all I get is :

Oct 13 15:17:33 almery kernel: [29162.468218] sas: sas_ata_phy_reset: 
Found ATA device.
Oct 13 15:17:33 almery kernel: [29162.470279] ata19.00: both IDENTIFYs 
aborted, assuming NODEV
Oct 13 15:17:33 almery kernel: [29162.470321] sas: sas_ata_phy_reset: 
Found ATA device.
Oct 13 15:17:33 almery kernel: [29162.472391] ata19.00: both IDENTIFYs 
aborted, assuming NODEV
Oct 13 15:17:33 almery kernel: [29162.472433] sas: sas_ata_phy_reset: 
Found ATA device.
Oct 13 15:17:33 almery kernel: [29162.474492] ata19.00: both IDENTIFYs 
aborted, assuming NODEV
Oct 13 15:17:33 almery kernel: [29162.474533] ata19.00: disabled
Oct 13 15:17:33 almery kernel: [29162.474572] sas: sas_ata_phy_reset: 
Found ATA device.
Oct 13 15:17:33 almery kernel: [29162.474627] scsi_alloc_sdev: 
Allocation failure during SCSI scanning, some SCSI devices might not be 
configured
 
 

Is there a way to get a disk to reinitialize itself without a reboot ?

Drives are SAMSUNG HD501LJ
Linux almery 2.6.31.1-vs2.3.0.36.14 #7 SMP Mon Oct 12 12:58:07 CEST 2009 
x86_64 GNU/Linux
with or withous vserver patch applied : same problem, kernel not tainted.

The problem occurs also when the disks are not in an md array.

Christian Vilhelm.

-- 
/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\
|       Christian Vilhelm : christian.vilhelm@univ-lille2.fr         |
|            Reality is for people who lack imagination              |
\____________________________________________________________________/
