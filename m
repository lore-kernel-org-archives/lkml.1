Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZADWb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZADWb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZADWbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:31:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32799 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZADWbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:31:49 -0500
Date: Sun, 4 Jan 2009 23:33:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104223346.GB1913@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <20090104023211.GJ4758@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104023211.GJ4758@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sat 2009-01-03 21:32:11, Theodore Tso wrote:
> On Sat, Jan 03, 2009 at 01:38:15PM +0100, Pavel Machek wrote:
> > +Requirements
> > +============
> > +
> > +Ext3 expects disk/storage subsystem to behave sanely. On sanely
> > +behaving disk subsystem, data that have been successfully synced will
> > +stay on the disk. Sane means:
> > +
> > +* writes to media never fail. Even if disk returns error condition during
> > +  write, ext3 can't handle that correctly, because success on fsync was already
> > +  returned when data hit the journal.
> > +
> > +	   (Fortunately writes failing are very uncommon on disks, as they
> > +	   have spare sectors they use when write fails.)
> 
> This is not unique to ext3; per the discussion two weeks ago, this is
> largely because of the fsync() interface not possibly being able to

Ok, so I guess I should split the patch to truly ext3-specific part,
and the part that is common for all the filesystems. I guess I'll need
some help with everything but ext2 and ext3...

> return errors caused by failures when creating or modifying parent
> directories.  Given this, it's a bit misleading to place this in the
> Documentation/filesystems/ext3.txt.  At the minimum it should include
> a discussion about what the issues might be, and given that pretty
> much any Unix/Linux filesystem doesn't have a way of reflecting these
> errors to application programs, it probably should be in a
> filesystem-independent documentation file.

Ok. I'll have to think about good name of that file.

> > +* either write caching is disabled, or hw can do barriers and they are enabled.
> > +
> > +	   (Note that barriers are disabled by default, use "barrier=1"
> > +	   mount option after making sure hw can support them). 
> 
> We really should get akpm to agree to accept the patch to default
> barriers by default instead.  :-)

:-). Yes, that would help a bit.

(No, it is not complete solution. barrier=0/writeback on should be
still documented as unsafe).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
