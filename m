Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZAFKgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZAFKgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZAFKg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:36:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:54265 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751339AbZAFKg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:36:26 -0500
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX19/Z7Zkcqt/W7rko70v4+EpwQ9gRAaHF2RbDx5hKT
	vNU+xRfDY1/5D+
Date: Tue, 6 Jan 2009 11:36:20 +0100
From: Matthias Andree <matthias.andree@gmx.de>
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       Martin =?iso-8859-15?Q?MOKREJ=A6?= 
	<mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090106103620.GC6700@merlin.emma.line.org>
Mail-Followup-To: Rob Landley <rob@landley.net>,
	Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
	Martin =?iso-8859-15?Q?MOKREJ=A6?= <mmokrejs@ribosome.natur.cuni.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <20090104224052.GE1913@elf.ucw.cz> <20090104233052.GG22958@mit.edu> <200901042149.27655.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901042149.27655.rob@landley.net>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Jan 2009, Rob Landley wrote:

> On Sunday 04 January 2009 17:30:52 Theodore Tso wrote:
> > On Sun, Jan 04, 2009 at 11:40:52PM +0100, Pavel Machek wrote:
> > > Not neccessarily.
> > >
> > > If I have a bit of precious data and lot of junk on the card, I want
> > > to copy out the precious data before the card dies. Reading the whole
> > > media may just take too long.
> > >
> > > That's probably very true for rotating harddrives after headcrash...
> >
> > For a small amount data, maybe; but the number of seeks is often far
> > more destructive than the amount of time the disk is spinning.  And in
> > practice, what generally happens is the user starts looking around to
> > make sure there wasn't anything else on the disk worth saving, and now
> > data is getting copied off based on human reaction time.  So that's
> > why I normally advise users that doing a full image copy of the disk
> > is much better than, say, "cp -r /home/luser /backup", or cd'ing
> > around a filesystem hierarchy and trying to save files one by one.
> 
> That would be true if the disk hardware wasn't doing a gazillion retries to 
> read a bad sector internally (taking 5 seconds to come back and report 
> failure), and then the darn scsi layer added another gazillion retries on top 
> of that, and the two multiply together to make it so slow that that when you 
> leave the thing copying the disk overnight it's STILL not done 24 hours later.  
> Going in and cherry picking individual files looks kind of appealing in that 
> situation.

Well, I recently (Dec 1st or so) had a venerable HDD fail with a couple
of bad sectors; with oldish backups (couple of days) (Samsung SP2004C
plugged to a VIA VT6420 in the south bridge, VT8237).

I couldn't use dd_rescue since the disk drive was detached by the OS
upon the disk's hitting the first error.

If it's a software or hardware fault I cannot say, FreeBSD
7.1-PRERELEASE showed the same behaviour as did the openSUSE 11.0 i686
kernels, but then again it might be either OS losing patience with the
drive doing excessive reads, or the drive actually violating the bus
protocols or hanging. It didn't need power cycling though, detaching and
reattaching the ATA bus was sufficient.

For me, recovery was possible with rsync (or cp -Rp): run rsync -avH
until the drive froze, figure which file was affected, note the name,
remount the drive, rm the affected file, and continue.

Is there a "don't retry reads" setting in the kernel that I miss?

(I still have the drive, so I can try some error handling patches if
desired.)

-- 
Matthias Andree
