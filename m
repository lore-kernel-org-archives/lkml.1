Return-Path: <linux-kernel-owner+w=401wt.eu-S1763759AbZDBPls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763759AbZDBPls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZDBPlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:41:35 -0400
Received: from THUNK.ORG ([69.25.196.29]:57983 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbZDBPle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:41:34 -0400
Date: Thu, 2 Apr 2009 11:41:23 -0400
From: Theodore Tso <tytso@mit.edu>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-git: cannot mount ext4/loop
Message-ID: <20090402154123.GG10642@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com> <20090401225351.GA22621@orion> <20090402055356.GC10642@mit.edu> <a4423d670904020042x6b76715du48a15e988a05019d@mail.gmail.com> <a4423d670904020439m621990bch9482d19f0e48e7d2@mail.gmail.com> <a4423d670904020547s72972089t3c135a92af6751d4@mail.gmail.com> <49D4BDF2.2070102@ph.tum.de> <20090402145436.GF10642@mit.edu> <49D4D74F.1020904@ph.tum.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4D74F.1020904@ph.tum.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 05:18:39PM +0200, Thiemo Nagel wrote:
> Theodore Tso wrote:
>> On Thu, Apr 02, 2009 at 03:30:26PM +0200, Thiemo Nagel wrote:
>>> When I added the block range checks, initially I was assuming that
>>> when EXTENTS_FL is not set, the inode->i_data *always* contains
>>> references to further blocks.  Ted showed me wrong and added the condition
>>>
>>> 	ISREG() || ISDIR() || ( ISLNK() && !is_fast_symlink() )
>>>
>>> before that assumption can be made.  But maybe we need some further
>>> restraints?
>>
>> It's a endian-problem; we're missing le32_to_cpu() in that patch.
>> Sparc is big-endian. 
>
> Sorry for that.

Could you also fix the types?  bref should have a type of __le32, not
unsigned int, and when you pass in the reference to
__ext4_check_blockref(), there was an inappropriate cast to unsigned
int which hid kernel's natural type checking to catch these sorts of
problems.

I haven't had time yet to check your other patches; could you also
take a quick scan to make sure we have all of the byte-swapping calls
needed for proper big-endian checking, that we're using the correct
__le32 types and not doing any casts?  I should have caught this when
I did my review of your patches, so this is also partially my fault.

Many thanks,

						- Ted
