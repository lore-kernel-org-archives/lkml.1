Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXJ0SVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXJ0SVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXJ0SU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:20:59 -0400
Received: from main.gmane.org ([80.91.229.2]:42437 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbXJ0SU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:20:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 10 w AHCI w NCQ = Spurius  I/O error
Date: Sat, 27 Oct 2007 14:31:06 -0400
Message-ID: <472383EA.20506@tmr.com>
References: <471FA857.8060702@tiendalinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-70-109-100-63.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <471FA857.8060702@tiendalinux.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nestor A. Diaz wrote:
> Hello People,
> 
> I need your help, this problem is turning me crazy.

Did you know there is a raid list?
> 
> I have created a RAID 10 using  a RAID0 configuration on top of a two 
> RAID1 devices (all software raid), like this:

You have created a raid 0+1, raid10 is a different thing. Given your 
setup, raid10 is probably what you *should* have created.
> 
> Personalities : [raid0] [raid1]
> md4 : active raid0 md2[0] md3[1]
>      605071872 blocks 64k chunks
> 
> md0 : active raid1 sdd3[3] sda3[0] sdc3[2] sdb3[1]
>      9791552 blocks [4/4] [UUUU]
> 
> md3 : active raid1 sdd2[2](F) sdb2[0]
>      302536000 blocks [2/1] [U_]
> 
> md1 : active raid1 sdd1[3] sda1[0] sdc1[2] sdb1[1]
>      240832 blocks [4/4] [UUUU]
> 
> md2 : active raid1 sda2[0] sdc2[1]
>      302536000 blocks [2/2] [UU]
> 
> unused devices: <none>
> 
> But the sdd device sometimes fail, i have changed the hard disk, check 
> the older sata drive, reformat using mke2fs -c -c (to check for media 
> errrors both read and write, no media problems found, change the sata 
> disk and the problem remains, also with a new sata hard disk).
> 
> The systema is a supermicro server 5015-mt+ with an ich7 ahci controller

[___snip___]
> 
> The RAID 1 builds perfectly, but five days after that, the system shows a:
> 
> end_request: I/O error, dev sdd, sector 144006110
> raid1: Disk failure on sdd2, disabling device.
> Operation continuing on 1 devices
> end_request: I/O error, dev sdd, sector 144006222
> end_request: I/O error, dev sdd, sector 144268814
> RAID1 conf printout:
> --- wd:1 rd:2
> disk 0, wo:0, o:1, dev:sdb2
> disk 1, wo:1, o:0, dev:sdd2
> RAID1 conf printout:
> --- wd:1 rd:2
> disk 0, wo:0, o:1, dev:sdb2

Hardware error, almost certainly. If you're using a hub, I suspect that 
first, then cables and heat problems, then the controller, in rough 
order of likelyhood.
> 
> a week before i get (under 2.6.18) the following message:
> 
[___lots more snip___]

> 
> I have updated from 2.6.18 to 2.6.22 expecting to not have the problem, 
> but the problem remains and i didn't know what could be the problem, the 
> problem  always happen on /dev/sdd, i use LVM on top of the RAID 10 
> software device.
> 
> I am not sure if the problem was because i create the RAID10 using two 
> RAID1 devices and then do a RAID0, or should i have to be used mdadm and 
> the level 10 option ?
> 
> Any suggestions will be welcome.
> 
Do you ever get errors in partitions which are not part of the raid0+1 
setup, like md1? If not, look at your partition tables to see if you 
have any strange values there.

Are all drives at the same firmware level?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

