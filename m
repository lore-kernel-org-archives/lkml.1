Return-Path: <linux-kernel-owner+w=401wt.eu-S934292AbXLNQ7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292AbXLNQ7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXLNQ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:59:36 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35846 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXLNQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:59:35 -0500
Date: Fri, 14 Dec 2007 11:58:33 -0500
Message-Id: <200712141658.lBEGwX0V002849@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org, Jim Kissel <jlk@osml.eu>
Subject: Re: [PATCH 2/2] Unionfs: clarify usage.txt mount options 
In-reply-to: Your message of "Fri, 14 Dec 2007 19:32:46 +0300."
             <4762B02E.7030102@msgid.tls.msk.ru> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <4762B02E.7030102@msgid.tls.msk.ru>, Michael Tokarev writes:
> Erez Zadok wrote:
> 
> > --- a/Documentation/filesystems/unionfs/usage.txt
> > +++ b/Documentation/filesystems/unionfs/usage.txt
> []
> > +OPTIONS can be any legal combination one of:
>                                        ^^^^^
> A small typo.

Thanks.  Will fix.

> > +
> > +- ro		# mount file system read-only
> > +- rw		# mount file system read-write
> > +- remount	# remount the file system (see Branch Management below)
> > +- incgen	# increment generation no. (see Cache Consistency below)
> > +
> > +BRANCH-OPTIONS can be either (1) a list of branches given to the "dirs="
> > +option, or (2) a list of individual branch manipulation commands, described
> > +in the "Branch Management" section below.
> 
> Should this (2) choice mention remount operation somehow?
> It seems the (2) case is about remount only.

I'll clarify it further.

> > +The "dirs=" option takes a colon-delimited list of directories to compose
> > +the union, with an optional branch mode for each of those directories.
> > +Directories that come earlier (specified first, on the left) in the list
> > +have a higher precedence than those which come later.  Additionally,
> 
> By the way, what is "precedence" here?  I mean, will unionfs always
> write to the first rw branch, or is it possible to write to some
> deeper branch too?
> 
> And finally, can a first (and all of them as well) branch be ro?

Sounds like more clarifications :-)

A unionfs mount can be readonly or readwrite.  If it's readonly, none of the
branches will be written to.  If the union is readwrite, then the leftmost
(highest priority) branch must be writeable (for copyup to take place); the
remaining branches can be any mix of read-write and read-only.

In a writeable union, Unionfs will create new files in the leftmost branch.
If one tries to modify a file in a readonly branch/media, unionfs will copy
it up to the leftmost branch and modify it there.  If you try to modify a
file from a writeable branch which is NOT the leftmost branch, then unionfs
will modify it in that branch; this is useful if you, say, unify differnet
packages (e.g., apache, sendmail, ftpd, etc.) and you want changes to
specific package files to remain logically in the directory where they came
from.

> Thanks.
> 
> /mjt

Erez.
