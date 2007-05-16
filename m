Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbXEPR1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbXEPR1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbXEPR1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:27:42 -0400
Received: from mail.tmr.com ([64.65.253.246]:39082 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936AbXEPR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:27:41 -0400
Message-ID: <464B3F23.50105@tmr.com>
Date: Wed, 16 May 2007 13:28:03 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jeff Zheng <Jeff.Zheng@endace.com>
CC: Neil Brown <neilb@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk is
 5TB
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com><6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com> <17994.19043.771733.453896@notabene.brown> <659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
In-Reply-To: <659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Zheng wrote:
> Here is the information of the created raid0. Hope it is enough.
>
>   
If I read this correctly, the problem is with JFS rather than RAID? Have 
you tried not mounting the JFS filesystem but just starting the array 
which crashes, so you can read bits of it, etc, and verify that the 
array itself is working?

And can you run an fsck on the filesystem, if that makes sense? I assume 
you got to actually write a f/s at one time, and I've never used JFS 
under Linux. I spent five+ years using it on AIX, though, complex but 
robust.
> The crashing one:
> md: bind<sdd>
> md: bind<sde>
> md: raid0 personality registered for level 0
> md0: setting max_sectors to 4096, segment boundary to 1048575
> raid0: looking at sde
> raid0:   comparing sde(5859284992) with sde(5859284992)
> raid0:   END
> raid0:   ==> UNIQUE
> raid0: 1 zones
> raid0: looking at sdd
> raid0:   comparing sdd(5859284992) with sde(5859284992)
> raid0:   EQUAL
> raid0: FINAL 1 zones
> raid0: done.
> raid0 : md_size is 11718569984 blocks.
> raid0 : conf->hash_spacing is 11718569984 blocks.
> raid0 : nb_zone is 2.
> raid0 : Allocating 8 bytes for hash.
> JFS: nTxBlock = 8192, nTxLock = 65536
>
> The working one:
> md: bind<sde>
> md: bind<sdf>
> md: bind<sdg>
> md: bind<sdd>
> md0: setting max_sectors to 4096, segment boundary to 1048575
> raid0: looking at sdd
> raid0:   comparing sdd(2929641472) with sdd(2929641472)
> raid0:   END
> raid0:   ==> UNIQUE
> raid0: 1 zones
> raid0: looking at sdg
> raid0:   comparing sdg(2929641472) with sdd(2929641472)
> raid0:   EQUAL
> raid0: looking at sdf
> raid0:   comparing sdf(2929641472) with sdd(2929641472)
> raid0:   EQUAL
> raid0: looking at sde
> raid0:   comparing sde(2929641472) with sdd(2929641472)
> raid0:   EQUAL
> raid0: FINAL 1 zones
> raid0: done.
> raid0 : md_size is 11718565888 blocks.
> raid0 : conf->hash_spacing is 11718565888 blocks.
> raid0 : nb_zone is 2.
> raid0 : Allocating 8 bytes for hash.
> JFS: nTxBlock = 8192, nTxLock = 65536
>
> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de] 
> Sent: Wednesday, 16 May 2007 12:04 p.m.
> To: Michal Piotrowski
> Cc: Jeff Zheng; Ingo Molnar; linux-raid@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org
> Subject: Re: Software raid0 will crash the file-system, when each disk
> is 5TB
>
> On Wednesday May 16, michal.k.k.piotrowski@gmail.com wrote:
>   
>>> Anybody have a clue?
>>>
>>>       
>
> No...
> When a raid0 array is assemble, quite a lot of message get printed
> about number of zones and hash_spacing etc.  Can you collect and post
> those.  Both for the failing case (2*5.5T) and the working case
> (4*2.55T) is possible.
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

