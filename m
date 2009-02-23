Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZBWBYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZBWBYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 20:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZBWBXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 20:23:51 -0500
Received: from thunk.org ([69.25.196.29]:52864 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbZBWBXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 20:23:51 -0500
Date: Sun, 22 Feb 2009 20:23:36 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Pavel Machek <pavel@ucw.cz>, Eric Sandeen <sandeen@redhat.com>,
       Jan Kara <jack@suse.cz>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090223012336.GK17066@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz> <499494E2.3060006@redhat.com> <20090213022336.GH6922@mini-me.lan> <20090222141532.GC1586@ucw.cz> <20090222231914.GI17066@mit.edu> <49A1E2D3.9000304@garzik.org> <49A1E3EB.8050708@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A1E3EB.8050708@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 06:46:51PM -0500, Jeff Garzik wrote:
>
> To be more clear / precise, this means actually performing the  
> guarantees we claim to the user.  For example,
>
> fsync(2) on ext2 should trigger a storage device writeback cache flush  
> [or equivalent guarantee via FUA].
>
> fsync(2) or journal commit on ext3 should trigger a flush [or equivalent  
> guarantee via FUA].
>
> Though, certainly, the user should be able to disable this strict  
> behavior and trade correctness for performance.

No argument here.  The *default* should be that we respect fsync().
However, the user should be able to configure with a reasonable amount
of granularity tradeoffs between safety and performance and/or battery
usage.

						- Ted
