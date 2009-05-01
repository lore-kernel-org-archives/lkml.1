Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbZEAUSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbZEAUSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbZEAUSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:18:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:19364 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbZEAUSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Bpt7mws3cG8td5wWq77fQlzbPX1ErqHN/zvTMUGFNxk5gmZmi5kr1ty7gnrRce3xm+
         uF219cfr9vHesqdw1cXjL4/NmYR+7T4jM3MEsObpH77hjhvDgmc+UhG5lj3Lq2qfZeCw
         DlLXU2eIcJ94UgTyJG0CwZ5O0AI93hBxXvU3U=
MIME-Version: 1.0
Date: Fri, 1 May 2009 15:18:20 -0500
Message-ID: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: Steve French <smfrench@gmail.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Cc: Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       Andrew Tridgell <tridge@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote on 05/01/2009 02:09:33 PM:
> On Fri, 2009-05-01 at 22:19 +0400, Michael Tokarev wrote:
> > Dave Kleikamp wrote:
> > > On Fri, 2009-05-01 at 13:47 -0400, Christoph Hellwig wrote:
> > >> On Fri, May 01, 2009 at 12:41:29PM -0500, Dave Kleikamp wrote:
> > >>> From: Andrew Tridgell <tridge@samba.org>
> > >>> Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
> > >>>
> > >>> When this option is enabled the VFAT filesystem will refuse to create
> > >>> new files with long names. Accessing existing files with long names
> > >>> will continue to work.
> > >>>
> > >>> File names to be created must conform to the 8.3 format.  Mixed case is
> > >>> not allowed in either the prefix or the suffix.
> > >> This doesn't make any sense as a compile time option. Might make sense
> > >> as a mount option, but I'd like to hear a rationale for it first.
> > >
> > > Some linux-based devices would be happy not to contain code to create
> > > the long name at all.
> >
> > Well, is that a rationale per se?  Which devices they are and why?
>
> Could be anything.  cameras, phones, etc.  Anything that might be
> mountable by a host computer in order to share files, or to write to a
> device that can be shared by other computers or devices.
>
> > But besides, why `msdos' filesystem is not sufficient?
> > It contains no code to create long file names and no code to
> > read such names either.
>
> An example, an mp3 player wants to read files with long mixed-case
> names, which can be manipulated on a host computer.  But it may not need
> to create files that don't fit the 8.3 syntax.
>
> Of course, msdos might be a good option for other devices.

msdos file system does not support other features that vfat does
(there are probably more than maximum volume and file size).
For those manufacturers who who would like to disable
creation of long file names, but allow reading long file names,
and handle FAT32 on disk format and maximum sizes, it seems
reasonable to give them a simple configure option for it.  It is
harder, and less effective, to make the corresponding change
to modify the mount helper and kernel code to add
a new mount option, because it can be bypassed trivially
at the command line (ie having to "force" mount to pass a "nolongfilename"
mount option, would be harder than a simple kernel configure option)

-- 
Thanks,

Steve
