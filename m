Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYIKVUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYIKVUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYIKVUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:20:04 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33108 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647AbYIKVUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:20:02 -0400
Date: Thu, 11 Sep 2008 17:20:01 -0400
To: Harun Scheutzow <harun04@scheutzow.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vfat file system extreme fragmentation on multiprocessor
Message-ID: <20080911212001.GD31271@csclub.uwaterloo.ca>
References: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de> <20080911191049.GB31271@csclub.uwaterloo.ca> <0ML31I-1KdsXT0vcs-0006v2@mrelayeu.kundenserver.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ML31I-1KdsXT0vcs-0006v2@mrelayeu.kundenserver.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 10:11:05PM +0200, Harun Scheutzow wrote:
> At 21:10 11.09.2008, Lennart Sorensen wrote:
> 
> Why do you start a flame war against fat fs without the proper knowledge? This is of no help.

I am not.  FAT was nice and simple and did a nice job on floppies for
microsoft basic.  Fragmentation was no big deal.

> ext2 is no magic bullet. As any other file system which does not rearrange clusters on the fly (this is defragmentation), it can only prevent fragmentation by wasting space, that means it seems not to fragment at 25 % full, but does at 90 %, just depending on size of files created. Initially wasting space and on-the-fly defragmentation can be done on FAT as well, if the driver likes to do.

Certainly true.  I have had systems get amazingly slow with reiserfs3.6
in the past because I got too close to 100% full.  When not full they
tend to behave quite nicely for many workloads.  I am sure there are
workloads that will cause bad behaviour though.

> All this NOT the problem here. It is NOT what I'm asking for.
> 
> 
> >Now what would happen if you used ftruncate to extend the file you open
> >to a large size, and then started writing it, and then set the size
> >correctly at the end?
> 
> Because ftruncate has to allocate the clusters the same way fwrite does, it would probably give the same results.

But would ftruncate be a single operation in the kernel, reserving all
the clusters at once from the filesystem?  I doubt fwrite would write
50MB in a single chunk to any filesystem.  If it does write a single
chunk in one system call, well then I am quite impressed actually.

> Anyway, I want to keep things simple. I do not know the final file size in advance, may be 550 MByte, often 200, but can be 5. It is perfectly ok to get 4 fragments per 200 MByte. All I suggest is that a file system which is told to write 50 MByte a piece, does so.

Well that's why I thought maybe requesting 50MB or 100MB at a time with
ftruncate might work OK, and if the kernel handles it as a single
operation and reserves all the clusters at once when calling ftruncate,
then you would avoid fragmentation.  Seems simple enough and worth a
try.  At least if it works then you get to control the fragment size,
even if you can't prevent fragments.

Unfortunately if I understand the fat code correctly in the kernel, the
fat driver doesn't permit extending files with ftruncate, only
shortening, so I guess that doesn't help at all.

> I do not want to synchronize the two applications, preventing them from writing at the same time. But currently this seems to be the only option.

That does seem like a pain.  Not sure there are any other options in the
case of the fat filesystem under linux though.

-- 
Len Sorensen
