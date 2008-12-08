Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYLHQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYLHQOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYLHQOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:14:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57384 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYLHQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:14:10 -0500
Date: Mon, 8 Dec 2008 17:14:09 +0100
From: Pavel Machek <pavel@suse.cz>
To: mtk.manpages@gmail.com
Cc: linux-doc@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: fsync.2 does not mention error handling
Message-ID: <20081208161408.GA8163@atrey.karlin.mff.cuni.cz>
References: <20081202120645.GA5327@elf.ucw.cz> <cfd18e0f0812041112u23843f00rad92fba8badb43c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0812041112u23843f00rad92fba8badb43c6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pavel,

> Could you provide some pointers to supporting information / mail
> threads, relating to this?

Mail thread on lkml, "writing to disk, not...."

> > write file
> > fsync file
> > fsync .
> >
> > ... and someone else does "fsync ." in the meantime, you may get
> > success when in fact directory entry of file is not written to the
> > disk.

> Also, I'm still not 100% clear what you are saying above.  Do you mean
> that in this scenario, an error may occur but the first caller above
> won't know of it?

Yes.

>  (It would help if you could write a few sentences
> that you think should be in the man page.)

Ok, see below.

> > fsync() transfers ("flushes") all modified in-core data of (i.e.,
> > modified buffer cache pages for) the file referred to by the file
> > descriptor fd to the disk device (or other permanent storage device)
> > where that file resides.  The call blocks until the device reports
> > that the transfer has completed.  It also flushes metadata information
> > associated with the file (see stat(2)).
> >
> > Calling fsync() does not necessarily ensure that the entry in the
> > directory containing the file has also reached disk.  For that an
> > explicit fsync() on a file descriptor for the directory is also
> > needed.

Replace paragraph with:

On newly created files, explicitely calling fsync on a file descriptor
for a directory is also needed, because calling fsync() on file does
not necessarily ensure that the entry in the directory containing the
file has reached disk.

> >
> > ...
> > RETURN VALUE         top
> >
> > On success, these system calls return zero.  On error, -1 is
> > returned, and errno is set appropriately.

I'd add:

After I/O error, fsync() only returns error condition to the first
process that finishes fsync(). Therefore special care must be taken to
coordinate different processes trying to write data to file/directory.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
