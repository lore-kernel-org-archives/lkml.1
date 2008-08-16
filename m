Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYHPFTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYHPFTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 01:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYHPFTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 01:19:46 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:28949 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYHPFTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 01:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z3V6KR+166bkLCl44eWRH0bW4gPcdfgR2Ju2kRwrzDoVPi3YxHcXSZVVux6vQAu0Ox
         2nv4BeCSVRV87mDEGKxxXskO9lKI+6L2LlbMSt58AhJUC1oa11u0trbBdUgm/V+UMDcj
         RYQW0h+jsTrCbC5h7UXkAbGctfiZZpzrybEao=
Message-ID: <e7d8f83e0808152219j50827f49nb9dd48cf44e082d2@mail.gmail.com>
Date: Sat, 16 Aug 2008 15:19:43 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Cc: david@lang.hm, rmeijer@xs4all.nl, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, "Eric Paris" <eparis@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Rik van Riel" <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>
In-Reply-To: <20080815210942.4e342c6c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
	 <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
	 <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
	 <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
	 <20080815210942.4e342c6c@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 2:09 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sat, 16 Aug 2008 13:57:50 +1000
> "Peter Dolding" <oiaohm@gmail.com> wrote:
>> Anti-Virus has been for years about chasing the threat.   Lets try to
>> get in front of it.  You thread model needs a major update its
>> incomplete.
>>
>
> The problem TALPA is trying to solve is only part of the puzzle.
> Everyone recognizes that. It's a very relevant part of the puzzle (in
> corporate context at least), but it's very much so not a complete
> puzzle. Does that mean we shouldn't deal with this just because it's
> incomplete? Absolutely not!

TALPA idea I agree with.  As the long term forever solution I don't
agree with due to its location.

Lets look at the general disk to memory path.

[file system driver]
[file system drivers caches]
[inode's]  TALPA links in here and basically runs its own scan cache.

Long term TALPA need to move from the inode layor down and the design
of the file system path needs to change.

[file system driver]
[generic file system cache]  TALPA enters here and spreads.
[inodes]

generic file system cache built in a way that it can store all the non
linux permission and related data that the file system driver needs.

Reasons
1. That shape even if file system extra permissions are decided to be
kept hidden from the rest of Linux anti-virus can scanning can see it.
2. Everything that is in memory  is checked.
3. Infected files can be removed from consuming memory in the file
system cache.  So a raw memory scan of Linux will not trip on viruses
still being present in memory even that TALPA is running.  False
positive suggesting TALPA has failed is possible due to its current
location.
4 share caching of passed and failed with the file system cache.

1 virus removed from a file system cache could equal the complete
memory price of running TALPA.

Its TALPA location I have major issue with.   Being blind to full set
of information to make a judgement call is the other.

I see it in the same cat a unionfs fine as a side patch to main
kernel.   Not fine to enter main kernel due to being in the wrong
place.  Its the balancing act if we let TALPA will it ever develop
down to the location where it should be?

Can you say 100 percent that TALPA is in the right location for what
it is doing.   If it is not its a good temp fix until we can get
developed the solution in the correct location.  Temp fixes normally
never get main line.

Be truthful its simply in the wrong place.   Getting it to the correct
location for most effective memory usage and giving a virus the least
ammont of distance into linux.  Scanned and 100 percent booted out of
memory.  Other thing some file system drivers also keep stuff in there
cache independent to inodes.   So spots at moment can be double
scanned even that the complete time everything was in memory because
the inode was freed and the file system cache still had it.

You want the most effective use of CPU? if no go head with TALPA.

Current TALPA fails too many holes and flaws.   All caused by 1 thing
its location.   Yes its a major job to move it to the correct location
its a major file system operation rework.

TALPA unfortunately is like trying to build a house on quick sand.
Foundations it needs to work correctly and 100 percent effectively
currently not present.   The quick sand of many file system caches had
to come back and bite at some point.  The blocking of seeing all the
file system permissions also had to come back and bite at some point.

Fix the foundations TALPA idea will be solid for its section of the
puzzle.   Sticking head in sand and saying the foundations don't have
major issues is just fooling to your self.  LIM and others patches
trying to be put in also have the same quick sand issue.

Peter Dolding
