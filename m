Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbZFZRB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbZFZRB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbZFZRBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:01:07 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37891 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZFZRBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Wrk2rjY5JZdTM6XVH7RjWxYMLTonHXpct+m87lI9wKPPrFRyjh80dqUR8UmtsqLh0p
         m7lz9Tv3MktPphFvB3a+0ml/x5Rgk6vRixbQmdCbe0JRDai1+PHnp6/3vlocEuwAFkNg
         aO56mQU0zAuKJEIQY5VRKJeNuMTK/8uJn7dzs=
Message-ID: <4A44FDDB.1000902@gmail.com>
Date: Fri, 26 Jun 2009 18:56:59 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090614114613.GC9514@shareable.org> <4A351FA9.1090808@gmail.com> <20090616150750.GF29040@shareable.org> <4A37EF4A.1080006@gmail.com> <20090624174140.GH14121@shareable.org> <2ea1731b0906242344x5c8a6e58t5f82377be3d73411@mail.gmail.com> <20090626113016.GB17737@shareable.org>
In-Reply-To: <20090626113016.GB17737@shareable.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Marco Stornelli wrote:
>> 2009/6/24 Jamie Lokier <jamie@shareable.org>:
>>> Marco wrote:
>>> If it loses power when doing atomic rename (to replace config files,
>>> for example), it's likely that the whole /pramfs/configs/ directory
>>> will be corrupt, because the rename is writing to the directory inode,
>>> so you lose access to all names in that directory?
>>>
>>> That sounds like it can't be used for persistent configuration data.
>> It's true from this point of view currently there is a lack for this
>> and it needs a bit of effort to resolve this problem.  >From this
>> point of view I'd like to point out that I know that there was some
>> aspects to study in a deeper way, so I'll need of more then one
>> review :) but since this fs has been abandoned since 2004 and it
>> hadn't ever reviewed, it was important to do a serious review with
>> the kernel community to understand all the problems.
> 
> That's reasonable.
> 
> What do you think of my suggestion to double-buffer writes using a
> single fixed position block, as explained elsewhere in this thread?
> 
> It should give the power fail safety with very little code.  I don't
> know how much it would slwo down writing.  That probably depends on
> whether it's the checksum which is slow (which only needs to be done
> once when double-buffering), or the writing.
> 
> -- Jamie
> 

Yeah it can be a choice. For this fs it's important to use "simple" but
useful mechanism. What do you exactly mean with "fixed position block"?
A fixed position in the fs? For example superblock+inodetable+in-use
bitmap+blocks+"double-buffering block"? Using a temp block of the same
size of blocks used, isn't it? I agree, but I think it needs more then
100 lines of code. Even with this simple schema it needs a mechanism
with a timeout to do the "commit" of the temp block, it needs a
mechanism to read the temp block instead of the "old" block or a
mechanism to write-back the temp block. So it can be implemented but it
needs a bit of effort. I think I'll implement it in the next release.

Marco
