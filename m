Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbYEQXQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbYEQXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 19:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYEQXQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 19:16:49 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:56679 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119AbYEQXQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 19:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=X463rLiyJuQLx+PWY0sS303VstuIQlOdlCbc+SGVJYKVGEBxjr+UpD1XSXE9eBPdstppfvuIXmjvp4DUwX9MKknMUVX6vISkJ8cLo8Ll6ae5T8pv8bjBucAPqxviON+OQOE2dARXcOU3XGstrY+O5wmKASuxY0qCZLgA3mO1fOA=
Message-ID: <482F6743.9000700@gmail.com>
Date: Sat, 17 May 2008 18:16:19 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David@santools.com
CC: Guy Watkins <linux-raid@watkins-home.com>,
       "'LinuxRaid'" <linux-raid@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Mechanism to safely force repair of single md stripe w/o hurting
 data integrity of file system
References: <251401c8b865$406535c3$3e01a8c0@exchange.rackspace.com>
In-Reply-To: <251401c8b865$406535c3$3e01a8c0@exchange.rackspace.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Lethe wrote:
> It will. But that defeats the purpose.  I want to limit repair to only the raid stripe that utilizes a specifiv disk with a block that I know has a unrecoverable reas error.  
> 
> -----Original Message-----
> 
> From:  "Guy Watkins" <linux-raid@watkins-home.com>
> Subj:  RE: Mechanism to safely force repair of single md stripe w/o hurting data integrity of file system
> Date:  Sat May 17, 2008 3:28 pm
> Size:  2K
> To:  "'David Lethe'" <david@santools.com>; "'LinuxRaid'" <linux-raid@vger.kernel.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> 
> } -----Original Message----- 
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid- 
> } owner@vger.kernel.org] On Behalf Of David Lethe 
> } Sent: Saturday, May 17, 2008 3:10 PM 
> } To: LinuxRaid; linux-kernel@vger.kernel.org 
> } Subject: Mechanism to safely force repair of single md stripe w/o hurting 
> } data integrity of file system 
> }  
> } I'm trying to figure out a mechanism to safely repair a stripe of data 
> } when I know a particular disk has a unrecoverable read error at a 
> } certain physical block (for 2.6 kernels) 
> }  
> } My original plan was to figure out the range of blocks in md device that 
> } utilizes the known bad block and force a raw read on physical device 
> } that covers the entire chunk and let the md driver do all of the work. 
> }  
> } Well, this didn't pan out. Problems include issues where if bad block 
> } maps to the parity block in a stripe then md won't necessarily 
> } read/verify parity, and in cases where you are running RAID1, then load 
> } balancing might result in the kernel reading the bad block from the good 
> } disk. 
> }  
> } So the degree of difficulty is much higher than I expected.  I prefer 
> } not to patch kernels due to maintenance issues as well as desire for the 
> } technique to work across numerous kernels and  patch revisions, and 
> } frankly, the odds are I would screw it up.  An application-level program 
> } that can be invoked as necessary would be ideal. 
> }  
> } As such, anybody up to the challenge of writing the code?  I want it 
> } enough to paypal somebody $500 who can write it, and will gladly open 
> } source the solution. 
> }  
> } (And to clarify why, I know physical block x on disk y is bad before the 
> } O/S reads the block, and just want to rebuild the stripe, not the entire 
> } md device when this happens. I must not compromise any file system data, 
> } cached or non-cached that is built on the md device.  I have system with 
> } >100TB and if I did a rebuild every time I discovered a bad block 
> } somewhere, then a full parity repair would never complete before another 
> } physical bad block is discovered.) 
> }  
> } Contact me offline for the financial details, but I would certainly 
> } appreciate some thread discussion on an appropriate architecture.  At 
> } least it is my opinion that such capability should eventually be native 
> } Linux, but as long as there is a program that can be run on demand that 
> } doesn't require rebuilding or patching kernels then that is all I need. 
> }  
> } David @ santools.com 
>  
> I thought this would cause md to read all blocks in an array: 
> echo repair > /sys/block/md0/md/sync_action 
>  
> And rewrite any blocks that can't be read. 
>  
> In the old days, md would kick out a disk on a read error.  When you added 
> it back, md would rewrite everything on that disk, which corrected read 
> errors. 
>  
> Guy 
>

I bet $500 is well below minimum wage in the US for the number of hours it would 
take someone to do this.

And I would say that if you have > 100TB in a single raid5/6 that would mean you 
had to have at least 100 disks in that array, and most people get nervous at 
 >8-16 disks in either raid5 or raid6 arrays, and the statistics of disks going 
bad, and the chance of a rebuild succeeding before another disk/block goes bad 
gets smaller and smaller as the number of disks increase, as you have noted you 
are at the point that it becomes unlikely that the rebuild will ever complete 
even with good disks in the array.   Most people build a number of smaller 
raid5/raid6 arrays and then LVM them together to get around this issue.   And on 
top of that the larger number of disks the greater the IO required to do a 
rebuild so the slower the rebuild potentially is.   And that is assuming that 
you don't have a bad batch of disks that has an abnormally high failure rate.

I know of a hardware disk arrays that handle the bad block issue by allocating 
(on initial array construction) a set of spare blocks on each disk.  On finding 
a bad block on a disk they relocated and rebuild just the bad block on the disk 
with the bad block from the stripe/parity and somehow note that the block on the 
bad disk has been relocated, and after some number of bad blocks on a given 
disk, they note that the given disk has too many bad blocks, and you that should 
"clone" and then fail the original disk over to the cloned disk once the clone 
is finished, but this sort of thing would seem to be rather non-trivial, though 
if someone would setup a clone of the bad disk, and rebuild the bad sector this 
would probably cut down the amount of time/IO required to complete a rebuild, 
though it would still take several hours, and things would get more complicated 
if you had another failure during that process.


                                            Roger
