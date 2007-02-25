Return-Path: <linux-kernel-owner+w=401wt.eu-S964979AbXBYQGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbXBYQGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 11:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964981AbXBYQGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 11:06:15 -0500
Received: from smtp-out12.alice.it ([85.37.17.107]:2791 "EHLO
	smtp-out12.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964979AbXBYQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 11:06:14 -0500
Message-ID: <45E1B3E6.60403@alice.it>
Date: Sun, 25 Feb 2007 17:05:58 +0100
From: Mario Vanoni <vanonim@alice.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061222 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.16.41 & 2.6.18.7 OK,   2.6.19.5 NOT,   2.6.18.8 KERNEL PANIC
References: <45E05D54.10508@alice.it> <20070224201902.a2a7b3da.randy.dunlap@oracle.com>
In-Reply-To: <20070224201902.a2a7b3da.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Feb 2007 16:06:00.0482 (UTC) FILETIME=[D78BF020:01C758F6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat, 24 Feb 2007 16:44:20 +0100 Mario Vanoni wrote:
> 
>> 2.6.18.7 vanilla & 2.6.16.41 vanilla:
>> /dev/hda CD/DVD
>> /dev/hda1 / IDE HD 160GB
>> /dev/hda2 swap
>> /dev/sda1 /xyz SATA HD 320GB
>> /dev/sda2 swap
>> /dev/sdb1 /zzz SATA HD 320GB
>> /dev/sdb2 swap
>> /dev/sdc1 /usb USB KEY 512MB

> For 2.6.19.*, does .config contain any CONFIG_ATA* entries?
> FYI, in 2.6.19, CONFIG_SCSI_SATA* config symbols were renamed to
> CONFIG_ATA*, so just using an oldconfig won't be sufficient
> for SATA support.

You are 100% right, I was lazy, thanks for the gentle blame.
2.6.19.5 vanilla works perfectly, 2.6.20.1 vanilla too!

>> ---
>> 2.6.18.8 vanilla: !!!
>> screen eating leftmost characters, then
>> kernel panic - not syncing: VFS: Unable to mount root fs on
>> unknown-block(3,65)
>> POWER SWITCH ultima ratio
>> ---

Strange error, due to a partially corrupted MBR (?):
2.6.19.5 with incorrect .config, lilo, SATA missing
reboot with old 2.6.18.7, OK
2.6.18.8 with old .config from 2.6.18.6,
lilo objects not seeing /dev/sdb and /dev/sdc,
reboot and kernel panic,
reboot with 2.6.18.7, OK
2.6.18.8 make mrproper and rm -r /lib/modules/2.6.18.8
make bzImage etc., lilo: 2.6.18.8 works perfectly.

Many thanks and kind regards
Mario Vanoni
