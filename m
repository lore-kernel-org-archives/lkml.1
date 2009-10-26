Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbZJZEII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbZJZEII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 00:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZJZEII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 00:08:08 -0400
Received: from THUNK.ORG ([69.25.196.29]:38857 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbZJZEIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 00:08:07 -0400
Date: Mon, 26 Oct 2009 00:08:10 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext2: Avoid WARN() messages when failing to write to
	the superblock
Message-ID: <20091026040810.GE18523@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
References: <1256016146-2677-1-git-send-email-tytso@mit.edu> <20091025062128.GA1391@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091025062128.GA1391@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 07:21:28AM +0100, Pavel Machek wrote:
> > +	if (buffer_write_io_error(sbh)) {
> > +		/*
> > +		 * Oh, dear.  A previous attempt to write the
> > +		 * superblock failed.  This could happen because the
> > +		 * USB device was yanked out.  Or it could happen to
> > +		 * be a transient write error and maybe the block will
> > +		 * be remapped.  Nothing we can do but to retry the
> > +		 * write and hope for the best.
> > +		 */
> > +		printk(KERN_ERR "EXT2-fs: %s previous I/O error to "
> > +		       "superblock detected", sb->s_id);
> 
> KERN_ALERT/KERN_CRITICAL?

Based on kerneloops.org logs, it's apparently very frequent that
clueless lusers rip out USB drives without bothering to unmount them
first.  (Or people by crappy laptops where the SD cards sticks out
slightly and is easily jostled.)  It's not clear we really want to be
issueing KERN_ALERT or KERN_CRITICAL messages when this very common
event happens.

						- TRed
