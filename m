Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbZH3HUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbZH3HUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 03:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZH3HUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 03:20:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41751 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZH3HUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 03:20:03 -0400
Date: Sun, 30 Aug 2009 09:19:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
       Rik van Riel <riel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090830071957.GA1656@ucw.cz>
References: <4A92F6FC.4060907@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <20090826122813.GI32712@mit.edu> <200908270106.15032.rob@landley.net> <alpine.DEB.2.00.0908262342120.6822@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908262342120.6822@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> I thought the reason for that was that if your metadata is horked, further
>> writes to the disk can trash unrelated existing data because it's lost track
>> of what's allocated and what isn't.  So back when the assumption was "what's
>> written stays written", then keeping the metadata sane was still darn
>> important to prevent normal operation from overwriting unrelated existing
>> data.
>>
>> Then Pavel notified us of a situation where interrupted writes to the disk can
>> trash unrelated existing data _anyway_, because the flash block size on the 16
>> gig flash key I bought retail at Fry's is 2 megabytes, and the filesystem thinks
>> it's 4k or smaller.  It seems like what _broke_ was the assumption that the
>> filesystem block size >= the disk block size, and nobody noticed for a while.
>> (Except the people making jffs2 and friends, anyway.)
>>
>> Today we have cheap plentiful USB keys that act like hard drives, except that
>> their write block size isn't remotely the same as hard drives', but they
>> pretend it is, and then the block wear levelling algorithms fuzz things
>> further.  (Gee, a drive controller lying about drive geometry, the scsi crowd
>> should feel right at home.)
>
> actually, you don't know if your USB key works that way or not. Pavel has 
> ssome that do, that doesn't mean that all flash drives do
>
> when you do a write to a flash drive you have to do the following items
>
> 1. allocate an empty eraseblock to put the data on
>
> 2. read the old eraseblock
>
> 3. merge the incoming write to the eraseblock
>
> 4. write the updated data to the flash
>
> 5. update the flash trnslation layer to point reads at the new location  
> instead of the old location.


That would need two erases per single sector writen, no? Erase is in
milisecond range, so the performance would be just way too bad :-(.
	   	     	 	     	      	       	       Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
