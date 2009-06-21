Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZFURjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZFURjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZFURi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:38:58 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:55591 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZFURi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pGwi+FdtgooLnhp0x6kxgDkNxVXE4XqHWopN3sffvdD7b9L4iSh0paouAagjKfICZc
         tHdr+DZfr7IsL/3+JavoLK3uZ9IshtGhvf+BDHDQ/tdcCpQkOgVYNP7XsCOMhOXzsSOb
         uh246I9RYVWnoyR2gf0BRlrDpPs7n7sw0YmBU=
Message-ID: <4A3E6F28.4090404@gmail.com>
Date: Sun, 21 Jun 2009 19:34:32 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz>
In-Reply-To: <20090621064040.GC1656@ucw.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>> Why is an entire filesystem needed, instead of simply a block driver
>>> if the ramdisk driver cannot be used?
>>>
>> >From documentation:
>>
>> "A relatively straight-forward solution is to write a simple block
>> driver for the non-volatile RAM, and mount over it any disk-based
>> filesystem such as ext2/ext3, reiserfs, etc.
>>
>> But the disk-based fs over non-volatile RAM block driver approach has
>> some drawbacks:
>>
>> 1. Disk-based filesystems such as ext2/ext3 were designed for optimum
>>    performance on spinning disk media, so they implement features such
>>    as block groups, which attempts to group inode data into a contiguous
>>    set of data blocks to minimize disk seeking when accessing files. For
>>    RAM there is no such concern; a file's data blocks can be scattered
>>    throughout the media with no access speed penalty at all. So block
>>    groups in a filesystem mounted over RAM just adds unnecessary
>>    complexity. A better approach is to use a filesystem specifically
>>    tailored to RAM media which does away with these disk-based features.
>>    This increases the efficient use of space on the media, i.e. more
>>    space is dedicated to actual file data storage and less to meta-data
>>    needed to maintain that file data.
> 
> So... what is the performance difference between ext2 and your new
> filesystem?
> 

About the "space" you can read a detailed documentation on the site:

http://pramfs.sourceforge.net/pramfs-spec.html

In addition I can do an example of "compact" information: ext2 uses
directory entry objects ("dentries") to associate file names to inodes,
and these dentries are located in data blocks owned by the parent
directory. In pramfs, directory inode's do not need to own any data
blocks, because all dentry information is contained within the inode's
themselves.

>From performance point of view:

Sometimes ago I uploaded here (http://elinux.org/Pram_Fs) some benchmark
results to compare the performance with and without XIP in a real
embedded environment with bonnie++. You could use it as reference point.

I hope I've answered to your question.

Regards,

Marco

