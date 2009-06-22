Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZFVGdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZFVGdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZFVGdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:33:12 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:44990 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZFVGdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IA2hmQa+P/coVICj2kgw6SdXhAWgpBDN3UId1koqiT9UvAHGoKx2G5KQGittXVZHdu
         dDSBiHfjXwqGmbG4p5Uf2EkkKJcdVM3STrCdFiw6iFgppj1QCbBbsQVR/0CYpCyEi30S
         X/VLPS3tIhyclmBt2EXqaYhC88gu5Zi/VOmQc=
MIME-Version: 1.0
In-Reply-To: <20090621205245.GC3254@elf.ucw.cz>
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org>
	 <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz>
	 <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz>
Date: Mon, 22 Jun 2009 08:33:07 +0200
Message-ID: <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/21 Pavel Machek <pavel@ucw.cz>:
>
>> >> 1. Disk-based filesystems such as ext2/ext3 were designed for optimum
>> >>    performance on spinning disk media, so they implement features such
>> >>    as block groups, which attempts to group inode data into a contiguous
>> >>    set of data blocks to minimize disk seeking when accessing files. For
>> >>    RAM there is no such concern; a file's data blocks can be scattered
>> >>    throughout the media with no access speed penalty at all. So block
>> >>    groups in a filesystem mounted over RAM just adds unnecessary
>> >>    complexity. A better approach is to use a filesystem specifically
>> >>    tailored to RAM media which does away with these disk-based features.
>> >>    This increases the efficient use of space on the media, i.e. more
>> >>    space is dedicated to actual file data storage and less to meta-data
>> >>    needed to maintain that file data.
>> >
>> > So... what is the performance difference between ext2 and your new
>> > filesystem?
>> >
>>
>> About the "space" you can read a detailed documentation on the site:
>>
>> http://pramfs.sourceforge.net/pramfs-spec.html
>
> I do not see any numbers there. Do you think you can save significant
> memory when storing for example kernel source trees?

There aren't benchmark, but I pointed it out because if you know ext2
you can do a comparison.

>
>> In addition I can do an example of "compact" information: ext2 uses
>> directory entry objects ("dentries") to associate file names to
>> inodes,
>
> I'm not sure that on-disk directory entry == dentry.
>
>> and these dentries are located in data blocks owned by the parent
>> directory. In pramfs, directory inode's do not need to own any data
>> blocks, because all dentry information is contained within the inode's
>> themselves.
>
> How do you handle hard-links, then?

Indeed hard-links are not supported :) Due to the design of this fs
there are some limitations explained in the documentation as not
hard-link, only private memory mapping and so on. However this
limitations don't limit the fs itself because you must consider the
special goal of this fs.

>
>> >From performance point of view:
>>
>> Sometimes ago I uploaded here (http://elinux.org/Pram_Fs) some benchmark
>> results to compare the performance with and without XIP in a real
>> embedded environment with bonnie++. You could use it as reference point.
>
> Well, so XIP helps. ext2 can do XIP too, IIRC. Is your performance
> better than ext2?
>
> Wait... those numbers you pointed me... claim to be as slow as
> 13MB/sec. That's very very bad. My harddrive is faster than that.
>                                                                        Pavel
>

As I said I did the test in a real embedded environment so to have
comparable result you should use the same environmente with the same
tools, with the same workload and so on.

Marco
