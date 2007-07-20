Return-Path: <linux-kernel-owner+w=401wt.eu-S939564AbXGTP6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939564AbXGTP6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938015AbXGTP6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:58:32 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56644 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937044AbXGTP6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:58:30 -0400
Date: Fri, 20 Jul 2007 11:58:08 -0400
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, apiszcz@solarrain.com
Subject: Re: Software RAID 5 - Two reads are faster than one on a SW RAID5?
Message-ID: <20070720155808.GA21547@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0707200952270.25069@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707200952270.25069@p34.internal.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 09:58:50AM -0400, Justin Piszcz wrote:
> I have a multi-core Q6600 CPU on a 10-disk Raptor RAID 5 running XFS.
> 
> I just pulled down the Debian Etch 4.0 DVD ISO's, one for x86 and one for 
> x86_64, when I ran md5sum -c MD5SUMS, I see ~280-320MB/s.  When I ran the 
> second one I see upwards of what I should be seeing 500-520MB/s.
> 
> NOTE:: These MD5 contain the 3 DVD ISO's for each platform, 6 total ISOs.
> 
> I know md5sum is cpubound to a degree, do you think that is what is 
> happening here?  Each core can only sustain ~300MB/s and then with two of 
> four cores working, it can exceed that amount or is there some similarity 
> with RAID1 in linux compared to RAID5?
> 
> With RAID1, if you use a single read thread, you will get 60-70MB/s read 
> on a dual raptor raid1.  If you use two(?) or three threads, it will read 
> from both disks and you will see 120-140MB/s.
> 
> Is there some commonality with software RAID1 and RAID5 in Linux in this 
> regard?

Could you just run top while doing md5sum and see how much cpu md5sum is
using on the cpu it is on?  After all if it says 100% for the process,
then yes it is cpu bound at 300MB/s, and if not then I guess there has
to be another explanation.

It looks pretty likely, since I just tried running md5sum on a 130MB
file here, and it takes 0.444s of user cpu time and 0.068s of system
time to process, and I ran it multiple times so the file ended up cached
in ram so disk speed isn't a concern, which I figure means my system
runs md5sum at about 250MB/s.  This is on a single core Athlon 64 3500+
(2.2GHz).  So if you have a slightly faster as you do with a 2.4GHz Core
2, then 300MB/s seems perfectly reasonable per core.  I don't quite know
how md5 hashes work, but I really doubt they are something you are
likely to be able to make threaded.

--
Len Sorensen
