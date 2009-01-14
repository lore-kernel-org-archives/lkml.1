Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbZANRC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbZANRC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763173AbZANRCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:02:20 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53121 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763037AbZANRCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:02:19 -0500
Date: Wed, 14 Jan 2009 11:59:52 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Jan Kara <jack@suse.cz>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090114165952.GH6222@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz> <20090114141204.GD6222@mit.edu> <20090114143756.GF19950@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114143756.GF19950@duck.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:37:56PM +0100, Jan Kara wrote:
> > Um, we have that already; the sync_inode() followed by
> > blkdev_issue_flush() is the path taken by fdatasync(), I do believe.
>
>   Maybe ext4-patch-queue changes that area but in Linus's tree I see:
> 
>   if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
>          goto out;
> 
>   So if we just overwrite some data, we send them to disk via fdatawrite()
> and then we quickly bail out from ext4_sync_file() without doing
> blkdev_issue_flush().

So you're thinking about fdatawrite() being called by some code path
other than ext4_sync_file() before we call fsync()?  Yeah, that could
happen....  I think that will only happen if the file is opened
O_SYNC, but that raises another issue, which is that we're not forcing
a flush for writes when the file is opened O_SYNC.

							- Ted
