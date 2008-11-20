Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYKTBSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYKTBSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 20:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYKTBSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 20:18:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbYKTBSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 20:18:40 -0500
Date: Wed, 19 Nov 2008 17:18:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Fuckner <michael@fuckner.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Nick Cheng <nick.cheng@areca.com.tw>, Erich Chen <erich@areca.com.tw>
Subject: Re: Performance issues with Areca 1680 SAS Controllers
Message-Id: <20081119171820.0823457d.akpm@linux-foundation.org>
In-Reply-To: <492403B8.5090007@fuckner.net>
References: <492403B8.5090007@fuckner.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k iflag=direct
> 51200+0 records in
> 51200+0 records out
> 53687091200 bytes (54 GB) copied, 59.6494 seconds, 900 MB/s
> [root@storage ~]# mount /dev/sdb1 /data
> [root@storage ~]# cd /data/
> [root@storage data]# ./iozone -i 0 -i 1 -s 32g -r 16m -S 6144 -t 8 -+r
> -o  >raid6_sync_t8.log
> [root@storage data]# cd
> [root@storage ~]# umount /data/
> [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k iflag=direct
> 51200+0 records in
> 51200+0 records out
> 53687091200 bytes (54 GB) copied, 76.4036 seconds, 703 MB/s
> 
> I tested different Versions of Linux (Centos 5.2, OpenSUSE 11, Debian
> Lenny) and Vanilla kernels 2.6.22-2.6.27, all show this behaviour.
> 
> Idea why the device slows down after IO- or better: how to keep the high
> rate? Is this reproducible foer Areca SATA Controllers (Type 11XX and 12XX)
> 
> Regards,
>    Michael!
