Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXDHB1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXDHB1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 21:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbXDHB1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 21:27:50 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:37354 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932469AbXDHB1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 21:27:48 -0400
Date: Sat, 7 Apr 2007 21:27:45 -0400
To: johnrobertbanks@fastmail.fm
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ignatich <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Message-ID: <20070408012745.GH3508@csclub.uwaterloo.ca>
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070407191715.GG3510@csclub.uwaterloo.ca> <1175993097.32498.1183512070@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175993097.32498.1183512070@webmail.messagingengine.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 05:44:57PM -0700, johnrobertbanks@fastmail.fm wrote:
> Lennart. Tell me again that these results from 
> 
> http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
> http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm

Hmm, copying kernel sources around.  Not that interesting.  How does it
handle mpeg2 files (the majority of my personal data files is on a
mythtv system).  So a few large files, with mostly linear access, and
the occational file deletion.  Compression would gain nothing.

> are not of interest to you. I still don't understand why you have your
> head in the sand.

Well I find it hard to get excited about new filesystems.  I had
sufficiently nasty data loses due to reiserfs 3 back in the early 2.4
kernel days, that I no longer get excited about new filesystems.  now I
want something I trust that hasn't destroyed any of my data.  I tried
XFS for a while, ut the early 2.6 kernels had some nasty bugs in XFS too
that made that pretty much unusable.  Now I just stick with ext3.  Screw
performance, give me something that works all the time.

> .-------------------------.
> | FILESYSTEM | TIME |DISK |
> | TYPE       |(secs)|USAGE|
> .-------------------------.
> |REISER4 lzo | 1938 | 278 |
> |REISER4 gzip| 2295 | 213 |
> |REISER4     | 3462 | 692 |
> |EXT2        | 4092 | 816 |
> |JFS         | 4225 | 806 |
> |EXT4        | 4408 | 816 |
> |EXT3        | 4421 | 816 |
> |XFS         | 4625 | 779 |
> |REISER3     | 6178 | 793 |
> |FAT32       |12342 | 988 |
> |NTFS-3g     |10414 | 772 |
> .-------------------------.
> 
> 
> Column one measures the time taken to complete the bonnie++ benchmarking
> test (run with the parameters bonnie++ -n128:128k:0)

Time without cpu usage is not interesting.  If you can increase
filesystem speed by 10% by doubling cpu load, then I don't want the
increase.  It is all relative.  Wall clock time by itself just doesn't
contain enough data to be useful.

> Column two, Disk Usage: measures the amount of disk used to store 655MB
> of raw data (which was 3 different copies of the Linux kernel sources).

I remember disk compression from the DOS days.  Disk space is too cheap
to bother with that crap anymore.  I don't care if it can theoretically
turn idle cpu cycles into improved disk speed.  Sometimes I don't have
idle cpu cycles to waste on that.

> OR LOOK AT THE FULL RESULTS:
> 
> .-------------------------------------------------.
> |File         |Disk |Copy |Copy |Tar  |Unzip| Del |
> |System       |Usage|655MB|655MB|Gzip |UnTar| 2.5 |
> |Type         | (MB)| (1) | (2) |655MB|655MB| Gig |
> .-------------------------------------------------.
> |REISER4 gzip | 213 | 148 |  68 |  83 |  48 |  70 |
> |REISER4 lzo  | 278 | 138 |  56 |  80 |  34 |  84 |
> |REISER4 tails| 673 | 148 |  63 |  78 |  33 |  65 |
> |REISER4      | 692 | 148 |  55 |  67 |  25 |  56 |
> |NTFS3g       | 772 |1333 |1426 | 585 | 767 | 194 |
> |NTFS         | 779 | 781 | 173 |   X |   X |   X |
> |REISER3      | 793 | 184 |  98 |  85 |  63 |  22 |
> |XFS          | 799 | 220 | 173 | 119 |  90 | 106 |
> |JFS          | 806 | 228 | 202 |  95 |  97 | 127 |
> |EXT4 extents | 806 | 162 |  55 |  69 |  36 |  32 |
> |EXT4 default | 816 | 174 |  70 |  74 |  42 |  50 |
> |EXT3         | 816 | 182 |  74 |  73 |  43 |  51 |
> |EXT2         | 816 | 201 |  82 |  73 |  39 |  67 |
> |FAT32        | 988 | 253 | 158 | 118 |  81 |  95 |
> .-------------------------------------------------.
> 
> 
> Each test was preformed 5 times and the average value recorded.
> Disk Usage: The amount of disk used to store the data (which was 3
> different copies of the Linux kernel sources).
> The raw data (without filesystem meta-data, block alignment wastage,
> etc) was 655MB.
> Copy 655MB (1): Copy the data over a partition boundary.
> Copy 655MB (2): Copy the data within a partition.
> Tar Gzip 655MB: Tar and Gzip the data.
> Unzip UnTar 655MB: UnGzip and UnTar the data.
> Del 2.5 Gig: Delete everything just written (about 2.5 Gig).
> 
> To get a feel for the performance increases that can be achieved by
> using compression, we look at the total time (in seconds) to run the
> test:

kernel sources are some of the most compressable data files around.  Try
with some interesting data instead, like something with larger files,
mostly binary, which isn't likely to compess very much.

> bonnie++ -n128:128k:0 (bonnie++ is Version 1.93c)
> 
> .-------------------.
> | FILESYSTEM | TIME |
> .-------------------.
> |REISER4 lzo |  1938|
> |REISER4 gzip|  2295|
> |REISER4     |  3462|
> |EXT4        |  4408|
> |EXT2        |  4092|
> |JFS         |  4225|
> |EXT3        |  4421|
> |XFS         |  4625|
> |REISER3     |  6178|
> |FAT32       | 12342|
> |NTFS-3g     |>10414|
> .-------------------.
> -- 

Well Reiser4 certainly looks impresive, but I still want to know what the
cpu load is like, what the repair tools are like, how well it handles
power failures in the middle of a write (I didn't like the way reiser3
would claim to have the filesystem back to a sane state, but the file
it had been in the middle of writing now contained garbage in many parts
of it, with no warning what so ever that this had taken place).

Performance looks impresive, but based on the history of reiser3 there
is a lot of historical damage to undo before I will even consider
testing it out.

--
Len Sorensen
