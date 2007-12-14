Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbXLNVdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbXLNVdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXLNVdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:33:04 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:27854 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbXLNVdB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:33:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B3o5xtZPYIzs/4DApHLn9/PGAr7efQFWG4EfmVCx9n/Z6rKotbuA4OtZg/vfpT+Y9SNCFE0NWpGIPT3GCh+2LcJDhsBg1kqJTFPfpFa7KqCT8OCdktJm/zXjjJ8hDtF+/ThURxJzAZZX85wsYFIyWJ6ck4xeej1XxFA11JsFlwU=
Message-ID: <e9aeeef80712141333n557325e3v11231b8bbe1b0963@mail.gmail.com>
Date: Fri, 14 Dec 2007 19:33:00 -0200
From: Denis <denismpa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: NFS , Kjournald - status D (uninterruptible sleep) - maquina lenta.
In-Reply-To: <e9aeeef80712141211v7cec29fdt7e2ec76bf877053f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <e9aeeef80712141011i139e6ec2pe04250bd56f338d8@mail.gmail.com>
	 <e9aeeef80712141211v7cec29fdt7e2ec76bf877053f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dears, I've got a double dual xeon wich sometimes is getting too slow.


While i was observing one of these slowly times, I realized the time
wait of processors come close to 100% and nfsd and kjournald process
become to D status (uniterruptible sleep) .Does someone know why this
can be happening or how can I troubleshoot it?

Below is a 'draw' of my top at one of these moments.

[root@cromo src]# top
top - 10:59:02 up 6 days, 19:30, 17 users,  load average: 14.77, 13.46, 13.00
Tasks: 189 total,   1 running, 188 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0% us,  0.4% sy,  0.0% ni,  0.2% id, 98.5% wa,  0.0% hi,  0.9% si
Cpu1  :  0.0% us,  0.4% sy,  0.0% ni,  0.0% id, 99.6% wa,  0.0% hi,  0.0% si
Cpu2  :  0.0% us,  0.2% sy,  0.0% ni,  7.8% id, 92.0% wa,  0.0% hi,  0.0% si
Cpu3  :  0.2% us,  0.8% sy,  0.0% ni,  0.0% id, 98.7% wa,  0.2% hi,  0.0% si
Mem:   4025540k total,  4018264k used,     7276k free,     7908k buffers
Swap:  4096564k total,     3288k used,  4093276k free,  3553252k cached

 3941 root      15   0     0    0    0 D    2  0.0  80:29.30 nfsd
 3938 root      15   0     0    0    0 D    1  0.0  81:02.02 nfsd
 2459 root      15   0     0    0    0 D    1  0.0  30:57.04 kjournald
 3937 root      15   0     0    0    0 D    1  0.0  82:07.99 nfsd
   96 root      15   0     0    0    0 S    0  0.0  34:12.48 kswapd0
 3940 root      15   0     0    0    0 D    0  0.0  80:22.55 nfsd
 3942 root      15   0     0    0    0 D    0  0.0  80:23.66 nfsd
 3939 root      15   0     0    0    0 D    0  0.0  82:22.55 nfsd
 4283 root      16   0 20936 8136 1276 S    0  0.2   0:44.47 hald
21289 denismpa  16   0  6280 1092  776 R    0  0.0   0:00.12 top
    1 root      16   0  4752  552  460 S    0  0.0   0:01.28 init
    2 root      RT   0     0    0    0 S    0  0.0   0:00.21 migration/0
    3 root      34  19     0    0    0 S    0  0.0   0:00.05 ksoftirqd/0
    4 root      RT   0     0    0    0 S    0  0.0   0:00.28 migration/1
    5 root      34  19     0    0    0 S    0  0.0   0:00.09 ksoftirqd/1
    6 root      RT   0     0    0    0 S    0  0.0   0:00.15 migration/2
    7 root      34  19     0    0    0 S    0  0.0   0:00.05 ksoftirqd/2
    8 root      RT   0     0    0    0 S    0  0.0   0:00.15 migration/3
    9 root      34  19     0    0    0 S    0  0.0   0:00.06 ksoftirqd/3
   10 root       5 -10     0    0    0 S    0  0.0   0:01.01 events/0
   11 root       5 -10     0    0    0 S    0  0.0   0:00.11 events/1
   12 root       5 -10     0    0    0 S    0  0.0   0:00.06 events/2
   13 root       5 -10     0    0    0 S    0  0.0    0:00.12 events/3
   14 root       5 -10     0    0    0 S    0  0.0   0:00.00 khelper
   15 root      15 -10     0    0    0 S    0  0.0   0:00.00 kacpid
   63 root       5 -10     0    0    0 S    0  0.0   0: 00.00 kblockd/0
   64 root       5 -10     0    0    0 S    0  0.0   0:00.00 kblockd/1
   65 root       5 -10     0    0    0 S    0  0.0   0:00.00 kblockd/2
   66 root       5 -10     0    0    0 S    0  0.0   0: 00.00 kblockd/3
   67 root      15   0     0    0    0 S    0  0.0   0:00.06 khubd
   97 root      12 -10     0    0    0 S    0  0.0   0:00.00 aio/0
   98 root       5 -10     0    0    0 S    0  0.0   0:00.00 aio/1
   99 root       5 -10     0    0    0 S    0  0.0   0:00.00 aio/2
  100 root       5 -10     0    0    0 S    0  0.0   0:00.00 aio/3
  244 root      23   0     0    0    0 S    0  0.0   0:00.00 kseriod
  359 root      20   0     0    0    0 S    0  0.0   0:00.00 scsi_eh_0
  360 root      15   0     0    0    0 S    0  0.0   0:00.00 aacraid
  379 root       5 -10     0    0    0 S    0  0.0   0:00.00 ata/0
  380 root       5 -10     0    0    0 S    0  0.0   0: 00.00 ata/1
  381 root       5 -10     0    0    0 S    0  0.0   0:00.00 ata/2
  382 root       8 -10     0    0    0 S    0  0.0   0:00.00 ata/3
  388 root      20   0     0    0    0 S    0  0.0   0:00.00 scsi_eh_1
  389 root      21   0     0    0    0 S    0  0.0   0:00.00 scsi_eh_2
  403 root      15   0     0    0    0 D    0  0.0   0:03.87 kjournald
 1708 root       6 -10  3604  444  364 S    0  0.0   0:00.00 udevd


Thanks and regards
 --
Denis Anjos.
Cisco Certified Network Associate.
Universidade Federal do ABC
Santo André - SP - BR
