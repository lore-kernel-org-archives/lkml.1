Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZAEJzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZAEJzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZAEJzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:55:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34007 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZAEJzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:55:01 -0500
Date: Mon, 5 Jan 2009 10:54:58 +0100
From: Pavel Machek <pavel@suse.cz>
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: [patch] Re: document ext3 requirements
Message-ID: <20090105095458.GC27199@atrey.karlin.mff.cuni.cz>
References: <20090103123813.GA1512@ucw.cz> <20090104220634.GD22958@mit.edu> <20090104230053.GG1913@elf.ucw.cz> <200901042042.36418.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901042042.36418.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sunday 04 January 2009 17:00:53 Pavel Machek wrote:
> > Document linux filesystem expectations. Ext3 can't handle write errors
> > of any kind, and can't handle non-atomic sector writes. Other
> > filesystems are probably even worse...
> 
> These concerns look like they're specifically for block backed filesystems, 
> which is one of four different types.  I wrote a longish incoherent
> rant to 

I updated the docs. It now states "block-backed filesystems" in the
first sentence.

> > +Write errors not allowed (NO-WRITE-ERRORS)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Writes to media never fail. Even if disk returns error condition
> > +during write, filesystems can't handle that correctly, because success
> > +on fsync was already returned when data hit the journal.
> > +
> > +	Fortunately writes failing are very uncommon on traditional
> > +	spinning disks, as they have spare sectors they use when write
> > +	fails.
> 
> The failures show up in dmesg(), and some filesystems will remount themselves 
> read only if the physical media driver manages to propogate an error back to 
> to the filesystem.  (Note that the scsi subsystem has historically

Well, you may get an error in dmesg(), but your data are already gone
at that point (and  apps don't read dmesg, anyway :-).

> Even sync() and fsync() won't help you there because if multiple processes do 
> that, only the _first_ one will get the physical media error.  (The filesystem 
> doesn't associate physical media errors with processes; there's too many 
> layers in between and it's not necessarily a 1:1 relationship
> anyway.)

sync() does not even have return value.

Yep. I'm trying to get fsync manpage updated.

> > +* either write caching is disabled, or hw can do barriers and they are
> > enabled. +
> > +	   (Note that barriers are disabled by default, use "barrier=1"
> > +	   mount option after making sure hw can support them).
> 
> So how does one make sure hw can support them?

hdparm -I reports them. If you don't see "Native Command Queueing",
you have a problem.

Interestingly, neither x60 notebook not pretty recent amd workstation
has NCQ... Amd notebook seems to be ok.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
