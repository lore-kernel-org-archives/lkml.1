Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbXLSBWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbXLSBWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXLSBWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:22:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXLSBWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:22:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071217185213.d0d02149.akpm@linux-foundation.org>
References: <20071217185213.d0d02149.akpm@linux-foundation.org> <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <30457.1197931451@turing-police.cc.vt.edu> <20071217145644.2d6374e4.akpm@linux-foundation.org> <11403.1197943676@turing-police.cc.vt.edu> <20071218023732.GA3215@darkstar.te-china.tietoenator.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Dave Young <hidave.darkstar@gmail.com>,
       Valdis.Kletnieks@vt.edu, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1 - wonky disk cache and CDROM behavior...
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 19 Dec 2007 01:22:21 +0000
Message-ID: <26475.1198027341@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > -			inode = ERR_PTR(ret);
> > +			return NULL;
> >  		} else {
> >  			unlock_new_inode(inode);
> >  		}
> > 
> 
> Yup.

Nope.  The correct fix is to make the various callers use IS_ERR() to check
the result of this function rather than checking for a NULL return.

> David, this is concerning.  More such error-path bugs in that code will take
> years and years to get found and fixed.

Yes, I know.  I've looked over the patches several times, however I know there
may be bugs in there because I may have made assumptions about what I've
written that cause me to overlook things.  It's a danger of checking your own
code:-(

> The best way to eliminate them is a line-by-line re-review of the patchset.

And ideally by someone other than me.  Some of them have been reviewed by
other people, but I'm not sure that all have.

However, I've just had another look through.  ISOFS appears to be the only one
in which I'd missed updating the callers.  I've sent you a patch for it.

Note that I expressed reservations about three filesystems in the cover note
(FAT, HPPFS and HOSTFS), but nothing seems to have come of it.

David
