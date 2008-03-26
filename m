Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYCZMgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYCZMgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbYCZMga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:36:30 -0400
Received: from smtp8-g19.free.fr ([212.27.42.65]:34071 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbYCZMga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:36:30 -0400
Date: Wed, 26 Mar 2008 13:36:32 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
Message-ID: <20080326133632.640aa0d2@harpe.intellique.com>
In-Reply-To: <e2e108260803260415w64fa4feave44560dd7ac7cbdb@mail.gmail.com>
References: <20080325194306.4ac71ff2@galadriel.home>
	<e2e108260803260142o34c33e7ajf395d5cb62824cb4@mail.gmail.com>
	<20080326120713.24cb8093@harpe.intellique.com>
	<e2e108260803260415w64fa4feave44560dd7ac7cbdb@mail.gmail.com>
Organization: Intellique
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 26 Mar 2008 12:15:57 +0100
"Bart Van Assche" <bart.vanassche@gmail.com> écrivait:

> You are welcome to post the numbers you obtained with dd for direct
> I/O on a RAID-1 setup for 2.4 versus 2.6 kernel.

Here we go (tested on a slightly slower hardware : Athlon64 3000+,
nVidia chipset) . Actually, direct IO result is identical. However, the
significant number for the end user in this case is the NFS thruput.

2.4 kernel (2.4.32), async write
--------------------------------
root@0[root]# ./dd if=/dev/zero of=/mnt/raid/testdd01 bs=1M count=1024 
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 13.407 seconds, 80.1 MB/s

2.4 kernel (2.4.32), async write thru NFS mount
--------------------------------
emmanuel[/mnt/temp]$ dd if=/dev/zero of=./testdd01 bs=1M count=1024 
1024+0 enregistrements lus
1024+0 enregistrements écrits
1073741824 bytes (1,1 GB) copied, 15,5176 s, 69,2 MB/s

2.4 kernel (2.4.32), async read
--------------------------------
root@0[root]# ./dd if=/mnt/raid/testdd01 of=/dev/null bs=1M
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 15.752 seconds, 68.2 MB/s

2.4 kernel (2.4.32), sync write
--------------------------------
root@0[root]# ./dd if=/dev/zero of=/mnt/raid/testdd01 bs=1M count=1024 \
oflag=direct,dsync 
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 21.7874 seconds, 49.3 MB/s

2.6 kernel (2.6.22.18), async write
--------------------------------
root@0[root]# ./dd if=/dev/zero of=/mnt/raid/testdd02 bs=1M
count=1024 1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 17.1347 seconds, 62.7 MB/s

2.6 kernel (2.6.22.18), async write thru NFS mount
--------------------------------
emmanuel[/mnt/temp]$ dd if=/dev/zero of=./testdd02 bs=1M count=1024
1024+0 enregistrements lus
1024+0 enregistrements écrits
1073741824 bytes (1,1 GB) copied, 21,3618 s, 50,3 MB/s

2.6 kernel (2.6.22.18), async read
--------------------------------
root@0[root]# ./dd if=/mnt/raid/testdd02 of=/dev/null bs=1M
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 15.7599 seconds, 68.1 MB/s

2.6 kernel (2.6.22.18), sync write
--------------------------------
root@0[root]# ./dd if=/dev/zero of=/mnt/raid/testdd02 bs=1M count=1024 \
oflag=direct,dsync 
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 21.7011 seconds, 49.5 MB/s

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

