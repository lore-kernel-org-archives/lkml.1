Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYBSJZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYBSJZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757470AbYBSJYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:24:46 -0500
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:33187 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755527AbYBSJYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:24:44 -0500
Message-ID: <47BAA064.5040509@vlnb.net>
Date: Tue, 19 Feb 2008 12:24:52 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: LKML <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org>
In-Reply-To: <47B980AC.2080806@wpkg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
> I have a 1.2 TB (of which 750 GB is used) filesystem which holds
> almost 200 millions of files.
> 1.2 TB doesn't make this filesystem that big, but 200 millions of files 
> is a decent number.
> 
> 
> Most of the files are hardlinked multiple times, some of them are
> hardlinked thousands of times.
> 
> 
> Recently I began removing some of unneeded files (or hardlinks) and to 
> my surprise, it takes longer than I initially expected.
> 
> 
> After cache is emptied (echo 3 > /proc/sys/vm/drop_caches) I can usually 
> remove about 50000-200000 files with moderate performance. I see up to 
> 5000 kB read/write from/to the disk, wa reported by top is usually 20-70%.
> 
> 
> After that, waiting for IO grows to 99%, and disk write speed is down to 
> 50 kB/s - 200 kB/s (fifty - two hundred kilobytes/s).
> 
> 
> Is it normal to expect the write speed go down to only few dozens of 
> kilobytes/s? Is it because of that many seeks? Can it be somehow 
> optimized? The machine has loads of free memory, perhaps it could be 
> uses better?
> 
> 
> Also, writing big files is very slow - it takes more than 4 minutes to 
> write and sync a 655 MB file (so, a little bit more than 1 MB/s) - 
> fragmentation perhaps?

It would be really interesting if you try your workload with XFS. In my 
experience, XFS considerably outperforms ext3 on big (> few hundreds MB) 
disks.

Vlad
