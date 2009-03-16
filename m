Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbZCPVqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbZCPVqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbZCPVpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:45:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35585 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760126AbZCPVpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:45:41 -0400
Date: Mon, 16 Mar 2009 22:48:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, tytso@mit.edu, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: ext2/3: document conditions when reliable operation is possible
Message-ID: <20090316214825.GC12308@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <87f94c370903161245u727090a7m93735d1b57971d9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87f94c370903161245u727090a7m93735d1b57971d9f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-03-16 15:45:36, Greg Freemyer wrote:
> On Thu, Mar 12, 2009 at 5:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
> <snip>
> > +Sector writes are atomic (ATOMIC-SECTORS)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Either whole sector is correctly written or nothing is written during
> > +powerfail.
> > +
> > +       Unfortuantely, none of the cheap USB/SD flash cards I seen do
> > +       behave like this, and are unsuitable for all linux filesystems
> > +       I know.
> > +
> > +               An inherent problem with using flash as a normal block
> > +               device is that the flash erase size is bigger than
> > +               most filesystem sector sizes.  So when you request a
> > +               write, it may erase and rewrite the next 64k, 128k, or
> > +               even a couple megabytes on the really _big_ ones.
> > +
> > +               If you lose power in the middle of that, filesystem
> > +               won't notice that data in the "sectors" _around_ the
> > +               one your were trying to write to got trashed.
> 
> I had *assumed* that SSDs worked like:
> 
> 1) write request comes in
> 2) new unused erase block area marked to hold the new data
> 3) updated data written to the previously unused erase block
> 4) mapping updated to replace the old erase block with the new one
> 
> If it were done that way, a failure in the middle would just leave the
> SSD with the old data in it.

The really expensive ones (Intel SSD) apparently work like that, but I
never seen one of those. USB sticks and SD cards I tried behave like I
described above.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
