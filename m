Return-Path: <linux-kernel-owner+w=401wt.eu-S1760674AbZANOJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbZANOJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZANOJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:09:24 -0500
Received: from brick.kernel.dk ([93.163.65.50]:14009 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZANOJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:09:24 -0500
Date: Wed, 14 Jan 2009 15:08:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>, sandeen@redhat.com
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090114140802.GC30821@kernel.dk>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114140532.GC19950@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14 2009, Jan Kara wrote:
> > I'm not sure what you mean; if the barrier operation isn't flushing
> > all of the caches all the way out to the iron oxide, it's not going to
> > be working properly no matter where it is being called, whether it's
> > in ext4_sync_file() or in jbd2's journal_submit_commit_record().
>   Well, I thought that a barrier, as an abstraction, only guarantees that
> any IO which happened before the barrier hits the iron before any IO which
> has been submitted after a barrier. This is actually enough for a
> journalling to work correctly but it's not enough for fsync() guarantees.
> But I might be wrong...

It also guarentees that when you get a completion for that barrier
write, it's on safe storage. Think of it as a flush-write-flush
operation, in the presence of write back caching.

-- 
Jens Axboe

