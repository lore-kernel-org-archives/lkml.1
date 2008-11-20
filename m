Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYKTHkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYKTHkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 02:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYKTHj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 02:39:58 -0500
Received: from mail.areca.com.tw ([220.130.178.143]:47616 "EHLO areca.com.tw"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589AbYKTHj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 02:39:58 -0500
From: "Nick Cheng" <nick.cheng@areca.com.tw>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Michael Fuckner'" <michael@fuckner.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       "'Erich Chen'" <erich@areca.com.tw>
References: <492403B8.5090007@fuckner.net> <20081119171820.0823457d.akpm@linux-foundation.org>
Subject: RE: Performance issues with Areca 1680 SAS Controllers
Date: Thu, 20 Nov 2008 15:39:40 +0800
Message-ID: <DB3A7CF1B9EB4E1B80FCEF215C16EA24@arecac12242173>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AclKrGln4I+ClMAJTjejSKEDyMwTmgANpU8g
In-Reply-To: <20081119171820.0823457d.akpm@linux-foundation.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-OriginalArrivalTime: 20 Nov 2008 07:29:17.0843 (UTC) FILETIME=[B26E2630:01C94AE1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,
I will get around handling your issue.
Thanks for your kindly patience,

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Thursday, November 20, 2008 9:18 AM
To: Michael Fuckner
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Nick Cheng;
Erich Chen
Subject: Re: Performance issues with Areca 1680 SAS Controllers

(cc's added)

On Wed, 19 Nov 2008 13:16:56 +0100
Michael Fuckner <michael@fuckner.net> wrote:

> Hi,
> 
> I am using an Areca 1680-SAS-Controller with 16 SAS-HDD (Seagate 1TB
> ST31000640SS). I set up a Raid6 with all 16 disks and formatted it with
> XFS. The Controller has 512MB RAM and a BBU. The OS is installed to
> another disk attached to the onboard AHCI controller.
> 
> After doing some IO, the areca raidset is slower compared to the rate 
> directly
> after boot.
> 
> 
> [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k
iflag=direct
> 51200+0 records in
> 51200+0 records out
> 53687091200 bytes (54 GB) copied, 59.6494 seconds, 900 MB/s
> [root@storage ~]# mount /dev/sdb1 /data
> [root@storage ~]# cd /data/
> [root@storage data]# ./iozone -i 0 -i 1 -s 32g -r 16m -S 6144 -t 8 -+r
> -o  >raid6_sync_t8.log
> [root@storage data]# cd
> [root@storage ~]# umount /data/
> [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k
iflag=direct
> 51200+0 records in
> 51200+0 records out
> 53687091200 bytes (54 GB) copied, 76.4036 seconds, 703 MB/s
> 
> I tested different Versions of Linux (Centos 5.2, OpenSUSE 11, Debian
> Lenny) and Vanilla kernels 2.6.22-2.6.27, all show this behaviour.
> 
> Idea why the device slows down after IO- or better: how to keep the high
> rate? Is this reproducible foer Areca SATA Controllers (Type 11XX and
12XX)
> 
> Regards,
>    Michael!

