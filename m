Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZAEDA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZAEDA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZAEDAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:00:19 -0500
Received: from mail.lang.hm ([64.81.33.126]:43192 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbZAEDAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:00:18 -0500
Date: Sun, 4 Jan 2009 20:02:05 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rob Landley <rob@landley.net>
cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
In-Reply-To: <200901042051.14269.rob@landley.net>
Message-ID: <alpine.DEB.1.10.0901041955360.25545@asgard.lang.hm>
References: <fa.P4z5CJpM0xT37PWJuOuCHDkO76o@ifi.uio.no> <fa.26o5IHCAC3TQdXupl62CLYwQ+Wk@ifi.uio.no> <49614284.8040201@yahoo.com> <200901042051.14269.rob@landley.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Rob Landley wrote:

> On Sunday 04 January 2009 17:13:08 Sitsofe Wheeler wrote:
>> Pavel Machek wrote:
>>> Is there linux filesystem that can handle that? I know jffs2, but
>>> that's unsuitable for stuff like USB thumb drives, right?
>>
>> This raises the question that if nothing can handle it which FS is the
>> least bad? The last I heard people were saying that with cheap SSDs the
>> recommendation was FAT [1] but in the future btrfs, nilfs and logfs
>> would be better.
>>
>> [1] http://lkml.org/lkml/2008/10/14/129
>
> I wonder if the flash filesystems could be told via mount options that they're
> to use a normal block device as if it was a flash with granularity X?
>
> They can't explicitly control erase, but writing to any block in a block group
> will erase and rewrite the whole group so they can just do large write
> transactions close to each other and the device should aggregate enough for an
> erase block.  (Plus don't touch anything _outside_ where you guess an erase
> block to be until you've finished writing the whole block, which they
> presumably already do.)

this capability would help for raid arrays as well.

if you have a raid5/6 array writing one sector to a stripe results in you 
reading the pairity block for that stripe, reading the rest of the sectors 
for the block on that disk, recalculating the pairity information and 
writing the changed sectors out to both disks.

if you are writing the entire stripe, you could calculate the pairity and 
just write everything out (no reads nessasary).

this would make sequential writes to raid5/6 arrays almost as fast as if 
they were raid0 stripes.

if you could define 'erase block size' to be the raid stripe size the same 
approach would work for both systems.

when I asked about the on the md list a couple of years ago, the response 
that I got was that it was a good idea, but there was no way to get the 
information about the low-level topology to the higher levels that would 
need to act on the information. now that there is a second case where this 
is needed, any mechanism that gets created should be made so that it's 
useable for both.

David Lang
