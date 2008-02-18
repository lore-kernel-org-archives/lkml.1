Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbYBRM5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbYBRM5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYBRM5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:57:24 -0500
Received: from mail.syneticon.net ([213.239.212.131]:48259 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYBRM5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:57:23 -0500
Message-ID: <47B980AC.2080806@wpkg.org>
Date: Mon, 18 Feb 2008 13:57:16 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: very poor ext3 write performance on big filesystems?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a 1.2 TB (of which 750 GB is used) filesystem which holds
almost 200 millions of files.
1.2 TB doesn't make this filesystem that big, but 200 millions of files 
is a decent number.


Most of the files are hardlinked multiple times, some of them are
hardlinked thousands of times.


Recently I began removing some of unneeded files (or hardlinks) and to 
my surprise, it takes longer than I initially expected.


After cache is emptied (echo 3 > /proc/sys/vm/drop_caches) I can usually 
remove about 50000-200000 files with moderate performance. I see up to 
5000 kB read/write from/to the disk, wa reported by top is usually 20-70%.


After that, waiting for IO grows to 99%, and disk write speed is down to 
50 kB/s - 200 kB/s (fifty - two hundred kilobytes/s).


Is it normal to expect the write speed go down to only few dozens of 
kilobytes/s? Is it because of that many seeks? Can it be somehow 
optimized? The machine has loads of free memory, perhaps it could be 
uses better?


Also, writing big files is very slow - it takes more than 4 minutes to 
write and sync a 655 MB file (so, a little bit more than 1 MB/s) - 
fragmentation perhaps?

+ dd if=/dev/zero of=testfile bs=64k count=10000
10000+0 records in
10000+0 records out
655360000 bytes (655 MB) copied, 3,12109 seconds, 210 MB/s
+ sync
0.00user 2.14system 4:06.76elapsed 0%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+883minor)pagefaults 0swaps


# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda              1,2T  697G  452G  61% /mnt/iscsi_backup

# df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sda                154M     20M    134M   13% /mnt/iscsi_backup




-- 
Tomasz Chmielewski
http://wpkg.org

