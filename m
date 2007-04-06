Return-Path: <linux-kernel-owner+w=401wt.eu-S1767534AbXDFEcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767534AbXDFEcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 00:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767533AbXDFEcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 00:32:13 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41019 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767296AbXDFEcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 00:32:12 -0400
Message-Id: <1175833931.8916.1183307802@webmail.messagingengine.com>
X-Sasl-Enc: sHu8KOZpP7FJCClGVVnfr3gvZrp8OkEziJ3C+t7yGVWL 1175833931
From: johnrobertbanks@fastmail.fm
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ignatich" <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <461592FB.5060507@zytor.com>
   <1175819681.20754.1183287946@webmail.messagingengine.com>
   <461596DE.2020802@zytor.com>
   <1175823288.25662.1183293506@webmail.messagingengine.com>
   <4615C780.5040407@zytor.com>
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: <4615C780.5040407@zytor.com>
Date: Thu, 05 Apr 2007 21:32:11 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

You say that the results may be accurate, but "Whether or not they're
*relevant* is a totally different ball of wax." and

"Whether or not they're relevant depends on how well they happen to
reflect your particular usage pattern."

Well, surprise, surprise,.. everyone knows that.

Have a look at the (summary) of the results: 

.-------------------------.
| FILESYSTEM | TIME |DISK |
| TYPE       |(secs)|USAGE|
.-------------------------.
|REISER4 lzo | 1938 | 278 |
|REISER4 gzip| 2295 | 213 |
|REISER4     | 3462 | 692 |
|EXT2        | 4092 | 816 |
|JFS         | 4225 | 806 |
|EXT4        | 4408 | 816 |
|EXT3        | 4421 | 816 |
|XFS         | 4625 | 779 |
|REISER3     | 6178 | 793 |
|FAT32       |12342 | 988 |
|NTFS-3g     |10414 | 772 |
.-------------------------.


for the full results see:
http://linuxhelp.150m.com/resources/fs-benchmarks.htm 

Don't you agree, that "If they are accurate,.... THEN they are obviously
very relevant."

I have set up a Reiser4 partition with gzip compression, here is the
difference in disk usage of a typical Debian installation on two 10GB
partitions, one with Reiser3 and the other with Reiser4.

debian:/# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3             10490104   6379164   4110940  61% /3
/dev/sda7              9967960   2632488   7335472  27% /7

Partitions 3 and 7 have exactly the same data on them (the typical
Debian install).

The partitions are exactly the same size (although df records different
sizes).

Partition 3 is Reiser3 -- uses 6.4 GB.
Partition 7 is Reiser4 -- uses 2.6 GB.

So Reiser4 uses 2.6 GB to store the (typical) data that it takes Reiser3
6.4 GB to store (note it would take ext2/3/4 some 7 GB to store the same
info).

Don't you think this result is significant in itself?

Following your hint I have booted /dev/sda7 and all the programs seem to
work fine. They do not seem to be any faster than when using Reiser3.

The whole system seems about as responsive as always.

For fun, I ran bonnie++. Here are the results:

debian:/# ./bonnie++ -u root
Using uid:0, gid:0.
Writing a byte at a time...done
Writing intelligently...done
Rewriting...done
Reading a byte at a time...done
Reading intelligently...done
start 'em...done...done...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.93c       ------Sequential Output------ --Sequential Input-
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
debian           1G   121  99 86524  21 63297  41   920  99 187762  80 
1782 233
Latency             82484us     386ms     438ms   26758us     110ms    
398ms
Version 1.93c       ------Sequential Create------ --------Random
Create--------
debian              -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
              /sec %CP
                 16 +++++ +++ +++++ +++ 18509  92 17776  86 +++++ +++
                 19495  91
Latency               210us    5475us    5525us    5777us    5522us   
5839us

I particularly liked the 233%CP for Random-Seeks.

John.



On Thu, 05 Apr 2007 21:07:28 -0700, "H. Peter Anvin" <hpa@zytor.com>
said:
> johnrobertbanks@fastmail.fm wrote:
> > Hi Peter,
> > 
> > You say that the results may be accurate, but not relevant.
> > 
> 
> NO, I said that whether they're accurate is another matter.
> 
> > If they are accurate,.... THEN they are obviously very relevant.
> 
> Crap-o-la.  Whether or not they're relevant depends on how well they 
> happen to reflect your particular usage pattern.
> 
> There are NO benchmarks which are relevant to all users.  Understanding 
> whether or not a benchmark is relevant to one's particular application 
> is one of the trickiest things about benchmarks.
> 
> 	-hpa
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - Email service worth paying for. Try it for free

