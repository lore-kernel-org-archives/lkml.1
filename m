Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXDAJZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXDAJZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 05:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXDAJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 05:25:39 -0400
Received: from mail.t-c-c.at ([82.150.200.3]:50558 "HELO mail.t-c-c.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932344AbXDAJZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 05:25:38 -0400
Message-ID: <460F7A87.3030201@gmx.at>
Date: Sun, 01 Apr 2007 09:25:27 +0000
From: "Florian D." <flockmock@gmx.at>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: cannot add device to partitioned raid6 array
References: <460EF263.7020505@gmx.at> <17935.8101.815473.709581@notabene.brown>
In-Reply-To: <17935.8101.815473.709581@notabene.brown>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Saturday March 31, flockmock@gmx.at wrote:
>> hi list!
>>
>> in short:
>> I created a partitioned raid6 array with 2 missing drives. Now, I want to add a device. It fails with:
>> flockmock ~ # mdadm -a /dev/md_d4 /dev/sdb2
>> mdadm: add new device failed for /dev/sdb2 as 4: Invalid argument
> 
> Thanks for the detailed problem report.
> 
> I think the cause of the error is that /dev/sdb2 is too small.
> It needs to be at least 490030594 sectors. How big is it?

but the *device* size should be only ~250GB, so the array size is ~500GB, no?

flockmock ~ # mdadm --detail /dev/md_d4
/dev/md_d4:
         Version : 00.90.03
   Creation Time : Sat Mar 31 19:48:58 2007
      Raid Level : raid6
      Array Size : 490030464 (467.33 GiB 501.79 GB)
   Used Dev Size : 245015232 (233.66 GiB 250.90 GB)
                   ^^^^^^^^^^

these disks are all 250 GB harddisks, formatted in the same way -- but they are from different 
vendors! The block sizes from the partitions vary a little bit (taken from /sbin/fdisk):

/dev/sda2: 245015347
/dev/sdc2: 245015347
/dev/sdb2: 244099642  -> different vendor

do you think that may be the cause?

thanks a lot,
florian

