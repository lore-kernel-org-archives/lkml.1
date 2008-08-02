Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYHBVzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYHBVzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 17:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYHBVzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 17:55:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:51996 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYHBVzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 17:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ifun2ZdZbJik7rxvxtgN6zc7FxxZ0p1npNDLIMkKygV0KOzSpGurBvqiAkpGqTPdmf
         BvJBR+IrWMsQjRAuGTMEZ/8qkN2tiqmdG5hNIox/9uYFZKcLysCtI47i9q5tGKuv8eFk
         KVnNs3QWrCnmEZanOaeatB32wv+qG4QIffBCM=
Message-ID: <4894D7C6.8030804@gmail.com>
Date: Sat, 02 Aug 2008 16:55:18 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linasvepstas@gmail.com
CC: Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>	 <200808012319.05038.alistair@devzero.co.uk> <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
In-Reply-To: <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:
> 2008/8/1 Alistair John Strachan <alistair@devzero.co.uk>:
>> On Friday 01 August 2008 18:30:34 Linas Vepstas wrote:
>>> Hi,
>>>
>>> I'm seeing strong, easily reproducible (and silent) corruption on a
>>> sata-attached
>>> disk drive on an amd64 board.  It might be the disk itself, but I
>>> doubt it; googling
>>> suggests that its somehow iommu-related but I cannot confirm this.
>> Nowhere do you explicitly say you have memtest86'ed the RAM.
> 
> It passes memtest86+ just fine. The system has been in heavy
> use doing big science calculations on big datasets (multi-gigabyte)
> for months; these do not get corrupted when copied/moved around
> on the old parallel IDE disk, nor moving/copying on an NFS mount
> to a file server. Only the SATA disk is misbehaving.

That MB uses DDR2 so I don't know if this is useful or not, I saw the issue on 
MB's using DDR.

I have seen issues when using all 4 dimm slots on a number of MB's that only 
appear to show up on DMA when using fast dual core cpus, if the CPU is slower 
things work just fine, and if you don't do heavy use of network or disk things 
are just fine.   And these machines would pass memtest without any issues.

You might try slowing down the cpu to the slowest and see if you can still 
duplicate it, if you cannot, bring the speed up a step and retest, if it only 
happens at the highest speed, it might be something similar.   In the end the 
solution was to have the MB maker add an option in the bios to slow down the 
ram, in the DDR case we had 4 double sided dimms (8 loads on the CPU) and AMD 
documents said DDR memory with 6 or more loads needed to be running at 333 and 
not 400, and as I said I don't know if it also applies to DDR2 in a similar way. 
   Note that if we used a slower dual core cpu it did not push things hard 
enough to show the error either, I believe we had the issues with 280/285's but 
not with 275's and lower (these were dual socket boards, with 4 dimms on each 
cpu, 8 loads per cpu).

                                  Roger
