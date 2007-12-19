Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbXLSCGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbXLSCGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 21:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbXLSCGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 21:06:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbXLSCF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 21:05:59 -0500
Date: Tue, 18 Dec 2007 18:04:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, Valdis.Kletnieks@vt.edu,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: 2.6.24-rc5-mm1 - wonky disk cache and CDROM behavior...
Message-Id: <20071218180458.c80a0575.akpm@linux-foundation.org>
In-Reply-To: <26475.1198027341@redhat.com>
References: <20071217185213.d0d02149.akpm@linux-foundation.org>
	<20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<30457.1197931451@turing-police.cc.vt.edu>
	<20071217145644.2d6374e4.akpm@linux-foundation.org>
	<11403.1197943676@turing-police.cc.vt.edu>
	<20071218023732.GA3215@darkstar.te-china.tietoenator.com>
	<26475.1198027341@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 01:22:21 +0000 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > -			inode = ERR_PTR(ret);
> > > +			return NULL;
> > >  		} else {
> > >  			unlock_new_inode(inode);
> > >  		}
> > > 
> > 
> > Yup.
> 
> Nope.  The correct fix is to make the various callers use IS_ERR() to check
> the result of this function rather than checking for a NULL return.
> 
> > David, this is concerning.  More such error-path bugs in that code will take
> > years and years to get found and fixed.
> 
> Yes, I know.  I've looked over the patches several times, however I know there
> may be bugs in there because I may have made assumptions about what I've
> written that cause me to overlook things.  It's a danger of checking your own
> code:-(
> 
> > The best way to eliminate them is a line-by-line re-review of the patchset.
> 
> And ideally by someone other than me.  Some of them have been reviewed by
> other people, but I'm not sure that all have.
> 
> However, I've just had another look through.  ISOFS appears to be the only one
> in which I'd missed updating the callers.  I've sent you a patch for it.
> 
> Note that I expressed reservations about three filesystems in the cover note
> (FAT, HPPFS and HOSTFS), but nothing seems to have come of it.
> 

Nobody seems to look after hppfs.  I'll resend the fat and hostfs patches to
maintainers for a review, please.
