Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbZC0QxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbZC0QxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZC0QxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:53:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33987 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757290AbZC0QxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:53:08 -0400
Date: Fri, 27 Mar 2009 16:51:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090327162841.GA26860@srcf.ucam.org>
References: <20090327032301.GN6239@mit.edu>
	<20090327034705.GA16888@srcf.ucam.org>
	<20090327051338.GP6239@mit.edu>
	<20090327055750.GA18065@srcf.ucam.org>
	<20090327062114.GA18290@srcf.ucam.org>
	<20090327112438.GQ6239@mit.edu>
	<20090327145156.GB24819@srcf.ucam.org>
	<20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	<20090327152221.GA25234@srcf.ucam.org>
	<20090327161553.31436545@lxorguk.ukuu.org.uk>
	<20090327162841.GA26860@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:28:41 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, Mar 27, 2009 at 04:15:53PM +0000, Alan Cox wrote:
> 
> > To be honest I don't see your problem. Surely well designed desktop
> > applications are already all using nice error handling, out of space and
> > fsync aware interfaces in the gnome library that do all the work for them
> > - "so they don't have to check for errors".
> 
> The context was situations like errors on close() not occuring unless 
> you've fsync()ed first. I don't think that error case is sufficiently 
> common to warrant the cost of an fsync() on every single close, 
> especially since doing so would cripple any application that ever tried 
> to run on ext3.

The fsync if you need to see all errors on close case has been true since
before V7 unix. Its the normal default behaviour on these systems so
anyone who assumes otherwise is just broken. There is a limit to the
extent the OS can clean up after completely broken user apps.

Besides which a properly designed desktop clearly has a single interface
of the form   

	happened = write_file_reliably(filename|NULL, buffer, len, flags)
	happened = replace_file_reliably(filename|NULL, buffer, len,
	flags (eg KEEP_BACKUP));

which internally does all the error handling, reporting to user, offering
to save elsewhere, ensuring that the user can switch app and make space
and checking for media errors. It probably also has an asynchronous
version you can bind event handlers to for completion, error, etc so that
you can override the default handling but can't fail to provide something
by default.  That would be designing failure out of the system.

IMHO the real solution to a lot of this actually got proposed earlier in
the thread. Adding "fbarrier()" allows the expression of ordering without
blocking and provides something new apps can use to get best performance.

Old properly written apps continue to work and can be improved, and sloppy
garbage continues to mostly work.

The file system behaviour is constrained heavily by the hardware, which
at this point is constrained by the laws of physics and the limits
of materials.

Alan
