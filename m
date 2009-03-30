Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZC3RoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZC3RoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZC3RoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:44:05 -0400
Received: from THUNK.ORG ([69.25.196.29]:49926 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbZC3RoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:44:04 -0400
Date: Mon, 30 Mar 2009 13:42:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330174207.GQ13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>, Mark Lord <lkml@rtr.ca>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <1238417751.30488.12.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238417751.30488.12.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 08:55:51AM -0400, Chris Mason wrote:
> Sorry, I'm afraid that rsync falls into the same category as the
> kde/gnome apps here.
> 
> There are a lot of backup programs built around rsync, and every one of
> them risks losing the old copy of the file by renaming an unflushed new
> copy over it.
> 
> rsync needs the flushing about a million times more than gnome and kde,
> and it doesn't have any option to do it automatically.  It does have the
> option to create backups, which is how a percentage of people are using
> it, but I wouldn't call its current setup safe outside of ext3.

I wouldn't make it to be the default, but as an option, if the backup
script would take responsibility for restarting rsync if the server
crashes, and if the rsync process executes a global sync(2) call when
it is complete, an option to make rsync delete the target file before
doing the rename to defeat the replace-via-rename hueristic could be
justifiable.

						- Ted
