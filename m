Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYKSMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYKSMZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYKSMZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:25:23 -0500
Received: from dedihh.fuckner.net ([81.209.183.161]:60180 "EHLO
	dedihh.fuckner.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbYKSMZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:25:22 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2008 07:25:22 EST
Message-ID: <492403B8.5090007@fuckner.net>
Date: Wed, 19 Nov 2008 13:16:56 +0100
From: Michael Fuckner <michael@fuckner.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080929)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Performance issues with Areca 1680 SAS Controllers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using an Areca 1680-SAS-Controller with 16 SAS-HDD (Seagate 1TB
ST31000640SS). I set up a Raid6 with all 16 disks and formatted it with
XFS. The Controller has 512MB RAM and a BBU. The OS is installed to
another disk attached to the onboard AHCI controller.

After doing some IO, the areca raidset is slower compared to the rate 
directly
after boot.


[root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k iflag=direct
51200+0 records in
51200+0 records out
53687091200 bytes (54 GB) copied, 59.6494 seconds, 900 MB/s
[root@storage ~]# mount /dev/sdb1 /data
[root@storage ~]# cd /data/
[root@storage data]# ./iozone -i 0 -i 1 -s 32g -r 16m -S 6144 -t 8 -+r
-o  >raid6_sync_t8.log
[root@storage data]# cd
[root@storage ~]# umount /data/
[root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k iflag=direct
51200+0 records in
51200+0 records out
53687091200 bytes (54 GB) copied, 76.4036 seconds, 703 MB/s

I tested different Versions of Linux (Centos 5.2, OpenSUSE 11, Debian
Lenny) and Vanilla kernels 2.6.22-2.6.27, all show this behaviour.

Idea why the device slows down after IO- or better: how to keep the high
rate? Is this reproducible foer Areca SATA Controllers (Type 11XX and 12XX)

Regards,
   Michael!
