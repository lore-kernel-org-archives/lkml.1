Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbZHYPfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbZHYPfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZHYPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:35:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:52542 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZHYPfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:35:51 -0400
Date: Tue, 25 Aug 2009 08:34:46 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
In-Reply-To: <20090825093414.GB15563@elf.ucw.cz>
Message-ID: <alpine.DEB.2.00.0908250829490.28411@asgard.lang.hm>
References: <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz>
 <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Pavel Machek wrote:

> Hi!
>
>>>> If your concern is that with Linux MD, you could potentially lose an
>>>> entire stripe in RAID 5 mode, then you should say that explicitly; but
>>>> again, this isn't a filesystem specific cliam; it's true for all
>>>> filesystems.  I don't know of any file system that can survive having
>>>> a RAID stripe-shaped-hole blown into the middle of it due to a power
>>>> failure.
>>>>
>>>
>>> Again, ext2 handles that in a way user expects it.
>>>
>>> At least I was teached "ext2 needs fsck after powerfail; ext3 can
>>> handle powerfails just ok".
>>
>> So, would you be happy if ext3 fsck was always run on reboot (at least
>> for flash devices)?
>
> For flash devices, MD Raid 5 and anything else that needs it; yes that
> would make me happy ;-).

the thing is that fsck would not fix the problem.

it may (if the data lost was metadata) detect the problem and tell you how 
many files you have lost, but if the data lost was all in a data file you 
would not detect it with a fsck

the only way you would detect the missing data is to read all the files on 
the filesystem and detect that the data you are reading is wrong.

but how can you tell if the data you are reading is wrong?

on a flash drive, your read can return garbage, but how do you know that 
garbage isn't the contents of the file?

on a degraded raid5 array you have no way to test data integrity, so when 
the missing drive is replaced, the rebuild algorithm will calculate the 
appropriate data to make the parity calculations work out and write 
garbage to that drive.

David Lang
