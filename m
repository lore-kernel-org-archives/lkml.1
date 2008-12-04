Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbYLDTMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbYLDTMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbYLDTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:12:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:45938 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbYLDTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:12:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=muUjJhAo/6xiZmJLBL0p/itNABlqjo+977q61IkwDex/eD/dElBgAVp8OaVWEMrSHo
         1O01O4Hc4+ix0CK+qIVUWAroW6q3hH/OCwl1/twxM2gu4Dw+YYdaRjDqSarVIePGyAwS
         0wf4CYPk1Ybi9Owlt1YjHb2/pEbwSpb+UFTv8=
Message-ID: <cfd18e0f0812041112u23843f00rad92fba8badb43c6@mail.gmail.com>
Date: Thu, 4 Dec 2008 14:12:11 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: fsync.2 does not mention error handling
Cc: linux-doc@vger.kernel.org, "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081202120645.GA5327@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081202120645.GA5327@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Tue, Dec 2, 2008 at 7:06 AM, Pavel Machek <pavel@suse.cz> wrote:
>
> fsync() transfers ("flushes") all modified in-core data of (i.e.,
> modified buffer cache pages for) the file referred to by the file
> descriptor fd to the disk device (or other permanent storage device)
> where that file resides.  The call blocks until the device reports
> that the transfer has completed.  It also flushes metadata information
> associated with the file (see stat(2)).
>
> Calling fsync() does not necessarily ensure that the entry in the
> directory containing the file has also reached disk.  For that an
> explicit fsync() on a file descriptor for the directory is also
> needed.
>
> ...
> RETURN VALUE         top
>
> On success, these system calls return zero.  On error, -1 is
> returned, and errno is set appropriately.
>
>
> --------------
>
>
> I guess it should mention that any errors during fsync are only
> mentioned to the first process calling it... which means that if you
>
> write file
> fsync file
> fsync .
>
> ... and someone else does "fsync ." in the meantime, you may get
> success when in fact directory entry of file is not written to the
> disk.

Could you provide some pointers to supporting information / mail
threads, relating to this?

Also, I'm still not 100% clear what you are saying above.  Do you mean
that in this scenario, an error may occur but the first caller above
won't know of it?  (It would help if you could write a few sentences
that you think should be in the man page.)

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
