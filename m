Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZBLQoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZBLQoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZBLQnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:43:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963AbZBLQnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:43:53 -0500
Message-ID: <499451A0.3070403@redhat.com>
Date: Thu, 12 Feb 2009 10:43:12 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext2 + -osync: not as easy as it seems
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz> <20090114140802.GC30821@kernel.dk>
In-Reply-To: <20090114140802.GC30821@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Jan 14 2009, Jan Kara wrote:
>>> I'm not sure what you mean; if the barrier operation isn't flushing
>>> all of the caches all the way out to the iron oxide, it's not going to
>>> be working properly no matter where it is being called, whether it's
>>> in ext4_sync_file() or in jbd2's journal_submit_commit_record().
>>   Well, I thought that a barrier, as an abstraction, only guarantees that
>> any IO which happened before the barrier hits the iron before any IO which
>> has been submitted after a barrier. This is actually enough for a
>> journalling to work correctly but it's not enough for fsync() guarantees.
>> But I might be wrong...
> 
> It also guarentees that when you get a completion for that barrier
> write, it's on safe storage. Think of it as a flush-write-flush
> operation, in the presence of write back caching.

(sorry for chiming in so late)

Jens, isn't this just the way it's implemented today?  At some point
couldn't a barrier bio simply be a reordering barrier that the storage
can use when destaging the write cache, rather than the heavy-handed
flush-write-flush we have today?

I guess it's a question of the intended semantics of a barrier bio, vs.
today's implementation based on current hardware functionality...

-Eric
