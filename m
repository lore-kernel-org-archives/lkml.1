Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZISSM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZISSM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZISSM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:12:29 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:43584 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZISSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=OWrPfaD3Wn0xuxjNZBLDUaPiYrwpOq2XxicpCfrhMJnAU3Cv320ypWc6209DEvLKzh
         rjXeXU1CupFU9Ia7gxyk8SgOkmiyI47DCHn85p3g1E8UM9CqhhuIqYV28Oh23cILbU6V
         guJt7ho0JORYVLzQl3BpehvTGMdGK5hIOurEc=
MIME-Version: 1.0
Date: Sat, 19 Sep 2009 20:12:31 +0200
Message-ID: <a769871e0909191112t3adb852cn93d72dc5fd94b9fd@mail.gmail.com>
Subject: EXT4 RAID read performance
From: wbrana@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm considering replacing Reiser3 filesystem with some newer one.
I ran compilebench benchmark. Read performance is lower with ext4.
Is it expected or is it possible to fix it?

Ext4:
read tree total runs 11 avg 20.47 MB/s (user 0.53s sys 0.74s)
read compiled tree total runs 4 avg 32.94 MB/s (user 0.61s sys 1.17s)

Reiser3:
read tree total runs 11 avg 26.33 MB/s (user 0.54s sys 0.81s)
read compiled tree total runs 4 avg 41.82 MB/s (user 0.62s sys 1.36s)

RAID details:

md8 : active raid10 sda7[0] sdd7[3] sdc7[2] sdb7[1]
      62925824 blocks 256K chunks 2 far-copies [4/4] [UUUU]

Ext4:
mkfs.ext4 -E stride=64,stripe-width=128 /dev/md8
mount -t ext4 -o noatime,auto_da_alloc,commit=600 /dev/md8 /mnt/md8

Reiser3:
mount -t reiserfs /dev/md8 /mnt/md8
mount -t reiserfs -o noatime,notail /dev/md8 /dev/md8

Ext4 results:
intial create total runs 10 avg 172.76 MB/s (user 0.43s sys 0.60s)
create total runs 14 avg 36.49 MB/s (user 0.42s sys 0.59s)
patch total runs 15 avg 15.16 MB/s (user 0.24s sys 0.49s)
compile total runs 14 avg 64.07 MB/s (user 0.10s sys 0.59s)
clean total runs 10 avg 393.43 MB/s (user 0.02s sys 0.06s)
read tree total runs 11 avg 20.47 MB/s (user 0.53s sys 0.74s)
read compiled tree total runs 4 avg 32.94 MB/s (user 0.61s sys 1.17s)
delete tree total runs 10 avg 2.51 seconds (user 0.24s sys 0.42s)
delete compiled tree total runs 4 avg 2.63 seconds (user 0.28s sys 0.50s)
stat tree total runs 11 avg 1.99 seconds (user 0.23s sys 0.18s)
stat compiled tree total runs 7 avg 2.11 seconds (user 0.27s sys 0.21s)

Reiser3 results:
intial create total runs 10 avg 82.74 MB/s (user 0.45s sys 1.13s)
create total runs 14 avg 28.54 MB/s (user 0.45s sys 1.19s)
patch total runs 15 avg 10.91 MB/s (user 0.24s sys 0.86s)
compile total runs 14 avg 47.49 MB/s (user 0.10s sys 1.27s)
clean total runs 10 avg 270.21 MB/s (user 0.02s sys 0.15s)
read tree total runs 11 avg 26.33 MB/s (user 0.54s sys 0.81s)
read compiled tree total runs 4 avg 41.82 MB/s (user 0.62s sys 1.36s)
delete tree total runs 10 avg 3.38 seconds (user 0.24s sys 0.72s)
delete compiled tree total runs 4 avg 4.14 seconds (user 0.27s sys 0.88s)
stat tree total runs 11 avg 2.09 seconds (user 0.22s sys 0.18s)
stat compiled tree total runs 7 avg 2.27 seconds (user 0.25s sys 0.21s)
