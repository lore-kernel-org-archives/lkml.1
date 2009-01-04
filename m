Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZADWx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZADWx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZADWxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:53:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43359 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZADWxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:53:48 -0500
Date: Sun, 4 Jan 2009 23:55:45 +0100
From: Pavel Machek <pavel@suse.cz>
To: Rob Landley <rob@landley.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       tytso@mit.edu, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104225545.GF1913@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901041349.49906.rob@landley.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-04 13:49:49, Rob Landley wrote:
> On Saturday 03 January 2009 06:38:15 Pavel Machek wrote:
> > +Ext3 expects disk/storage subsystem to behave sanely. On sanely
> > +behaving disk subsystem, data that have been successfully synced will
> > +stay on the disk. Sane means:
> > +
> > +* writes to media never fail. Even if disk returns error condition during
> > +  write, ext3 can't handle that correctly, because success on fsync was
> > already +  returned when data hit the journal.
> > +
> > +	   (Fortunately writes failing are very uncommon on disks, as they
> > +	   have spare sectors they use when write fails.)
> > +
> > +* either whole sector is correctly written or nothing is written during
> > +  powerfail.
> > +
> > +	   (Unfortuantely, none of the cheap USB/SD flash cards I seen do behave
> > +	   like this, and are unsuitable for ext3.
> 
> Want to document the granularity issues with flash, while you're at it?
> 
> An inherent problem with using flash as a normal block device is that the 
> flash erase size is bigger than most filesystem sector sizes.  So when you 
> request a write, it may erase and rewrite the next 64k, 128k, or even a couple 
> megabytes on the really _big_ ones.
> 
> If you lose power in the middle of that, ext3 won't notice that data in the 
> "sectors" _after_ the one your were trying to write to got trashed.
> 
> The flash filesystems take this into account as part of their wear levelling 
> stuff (they normally copy the entire chunk into a new chunk, leaving the old 
> one in place until it's no longer needed), but they need to query the device 
> to get the erase granularity in order to do that, which is why they don't work 
> on non-flash block devices.

Is there linux filesystem that can handle that? I know jffs2, but
that's unsuitable for stuff like USB thumb drives, right?

Does this sound like a fair summary?

Sector writes are atomic (ATOMIC-SECTORS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Either whole sector is correctly written or nothing is written during
powerfail.

        Unfortuantely, none of the cheap USB/SD flash cards I seen do
        behave like this, and are unsuitable for all linux filesystems
        I know.

                An inherent problem with using flash as a normal block
                device is that the flash erase size is bigger than
                most filesystem sector sizes.  So when you request a
                write, it may erase and rewrite the next 64k, 128k, or
                even a couple megabytes on the really _big_ ones.

                If you lose power in the middle of that, filesystem
                won't notice that data in the "sectors" _after_ the
                one your were trying to write to got trashed.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
