Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZJZH4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZJZH4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZJZH4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:56:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58353 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbZJZH4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:56:48 -0400
Date: Mon, 26 Oct 2009 08:56:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext2: Avoid WARN() messages when failing to write to
 the superblock
Message-ID: <20091026075645.GA22625@elf.ucw.cz>
References: <1256016146-2677-1-git-send-email-tytso@mit.edu>
 <20091025062128.GA1391@ucw.cz>
 <20091026040810.GE18523@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026040810.GE18523@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-10-26 00:08:10, Theodore Tso wrote:
> On Sun, Oct 25, 2009 at 07:21:28AM +0100, Pavel Machek wrote:
> > > +	if (buffer_write_io_error(sbh)) {
> > > +		/*
> > > +		 * Oh, dear.  A previous attempt to write the
> > > +		 * superblock failed.  This could happen because the
> > > +		 * USB device was yanked out.  Or it could happen to
> > > +		 * be a transient write error and maybe the block will
> > > +		 * be remapped.  Nothing we can do but to retry the
> > > +		 * write and hope for the best.
> > > +		 */
> > > +		printk(KERN_ERR "EXT2-fs: %s previous I/O error to "
> > > +		       "superblock detected", sb->s_id);
> > 
> > KERN_ALERT/KERN_CRITICAL?
> 
> Based on kerneloops.org logs, it's apparently very frequent that
> clueless lusers rip out USB drives without bothering to unmount them
> first.  (Or people by crappy laptops where the SD cards sticks out
> slightly and is easily jostled.)  It's not clear we really want to be
> issueing KERN_ALERT or KERN_CRITICAL messages when this very common
> event happens.

I'd say that frequency of the message should not determine the
priority. (If this happens on your root filesystem you are in deep
trouble, and it _should_ be broadcast on all consoles).

OTOH filesystem should be handle device unplug just fine, so not
issuing this in that case would be nice...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
