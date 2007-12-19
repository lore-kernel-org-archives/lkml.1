Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXLSBeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXLSBeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXLSBdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:33:52 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:21688 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479AbXLSBdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ANi+c8EkZZF0Xh496XqPl4ZXVFbYU8Ir6z23Ev7iiF7BCJTy/lok9EGMuHGvEeIyXfP22xHoU0cG9TWKsa+DxFa3FA7+X+USvXZteW9SvmDhulVpj8SRU8TZTYqkiD/wjbZMjoQPl9oeYiyenqmmQgU8jKLHEI9QEMVAdtlQn+g=
Message-ID: <a8e1da0712181733l10006686n9d694c5f289a6322@mail.gmail.com>
Date: Wed, 19 Dec 2007 09:33:50 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: 2.6.24-rc5-mm1 - wonky disk cache and CDROM behavior...
Cc: "Andrew Morton" <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <26475.1198027341@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	 <30457.1197931451@turing-police.cc.vt.edu>
	 <20071217145644.2d6374e4.akpm@linux-foundation.org>
	 <11403.1197943676@turing-police.cc.vt.edu>
	 <20071218023732.GA3215@darkstar.te-china.tietoenator.com>
	 <20071217185213.d0d02149.akpm@linux-foundation.org>
	 <26475.1198027341@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2007 9:22 AM, David Howells <dhowells@redhat.com> wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > > -                   inode = ERR_PTR(ret);
> > > +                   return NULL;
> > >             } else {
> > >                     unlock_new_inode(inode);
> > >             }
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
Hi,

The oops is at iput, I use 'return NULL ' is because I don't want to
change the the behaviour of iput in fs/inode.c.

Regards
dave
