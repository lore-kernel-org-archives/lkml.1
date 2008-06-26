Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbYFZSB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbYFZSB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYFZSBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:01:14 -0400
Received: from styx.suse.cz ([82.119.242.94]:43334 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751953AbYFZSBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:01:13 -0400
Date: Thu, 26 Jun 2008 19:05:14 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Michael Buesch <mb@bu3sch.de>, Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Oops when using growisofs
Message-ID: <20080626170513.GE23386@duck.suse.cz>
References: <200806221818.24372.mb@bu3sch.de> <200806242039.18755.mb@bu3sch.de> <20080625093700.GB15865@duck.suse.cz> <200806251146.30142.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806251146.30142.mb@bu3sch.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 25-06-08 11:46:29, Michael Buesch wrote:
> On Wednesday 25 June 2008 11:37:00 Jan Kara wrote:
> > > Yeah the IO error is the trigger.
> > > I noticed that it had obvious troubles accessing the DVD that was in the drive.
> > > It sweeped over it for several seconds, then hung the system for 2 or 3 seconds
> > > and then oopsed. But after that everything continued to work as usual.
> > > (Except kded of course)
> >   Hmm, by "accessing" do you mean that you've mounted the burned DVD and when
> > browsing it the IO error and the oops occured or that IO error happened
> > when burning? It is important because in the first case i_blkbits would be
> > taken from some ISOFS inode desribing some file while in the second case
> > i_blkbits are from the inode of the device...
> I don't know. kded, which caused the oops, is always running. It is a KDE daemon
> that polls device state and so on. So yeah, it might have accessed the drive
> while growisofs was writing to it.
> 
> However with "accessing" I mean the DVD drive motor was spinning up and down
> and the laser lens was moving like crazy. The sound that happens, if you put
> a completely scratched DVD into the drive and it is unable to make sense of it.
> However, this was not scratched. It was a new DVD with one session on it that
> I just burnt 5 minutes before that. So I wanted to append another session to it
> and it crashed and resulted in IO errors in growisofs.
  I've been looking into this problem for some time. The only way how I see
blocksize can be set so big is in cdrom_read_capacity() in
drivers/ide/ide-cd.c. That basically blindly fills in queue->hardsect_size with what
the drive returns and this can propagate in bd_set_size() to i_blkbits.
Jens, do you think that is possible? Shouldn't ide_cd_read_toc() do some
sanity checks of the blocksize returned?

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
