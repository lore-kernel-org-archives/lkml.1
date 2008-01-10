Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYAJKyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYAJKyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYAJKyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:54:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:17054 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYAJKyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fiw1CfRertCzYUcdmOLocLZEXC0Rs4Pm7a9EE/NSCRkrwYlbjAKeiKEfQx0zZ781R1Gzp8H+/+TFVULxQ29dj6kA7v0j6g1PmdmN2KtJPcFc55rJmZ/vqHMwwyYBx2GdxoqIi5PV0Eni3hZSR3uqpr4Pl5o3aUpAhkcI+1SX+C8=
Message-ID: <4df4ef0c0801100253m6c08e4a3t917959c030533f80@mail.gmail.com>
Date: Thu, 10 Jan 2008 13:53:59 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Jakob Oestergaard" <jakob@unthought.net>,
       "Anton Salikhmetov" <salikhmetov@gmail.com>,
       "Rik van Riel" <riel@redhat.com>, Valdis.Kletnieks@vt.edu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
In-Reply-To: <20080110085120.GK25527@unthought.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199728459.26463.11.camel@codedot>
	 <20080109155015.4d2d4c1d@cuia.boston.redhat.com>
	 <26932.1199912777@turing-police.cc.vt.edu>
	 <20080109170633.292644dc@cuia.boston.redhat.com>
	 <20080109223340.GH25527@unthought.net>
	 <20080109184141.287189b8@bree.surriel.com>
	 <4df4ef0c0801091603y2bf507e1q2b99971c6028d1f3@mail.gmail.com>
	 <20080110085120.GK25527@unthought.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/10, Jakob Oestergaard <jakob@unthought.net>:
> On Thu, Jan 10, 2008 at 03:03:03AM +0300, Anton Salikhmetov wrote:
> ...
> > > I guess a third possible time (if we want to minimize the number of
> > > updates) would be when natural syncing of the file data to disk, by
> > > other things in the VM, would be about to clear the I_DIRTY_PAGES
> > > flag on the inode.  That way we do not need to remember any special
> > > "we already flushed all dirty data, but we have not updated the mtime
> > > and ctime yet" state.
> > >
> > > Does this sound reasonable?
> >
> > No, it doesn't. The msync() system call called with the MS_ASYNC flag
> > should (the POSIX standard requires that) update the st_ctime and
> > st_mtime stamps in the same manner as for the MS_SYNC flag. However,
> > the current implementation of msync() doesn't call the do_fsync()
> > function for the MS_ASYNC case. The msync() function may be called
> > with the MS_ASYNC flag before "natural syncing".
>
> If the update was done as Rik suggested, with the addition that msync()
> triggered an explicit sync of the inode data, then everything would be ok,
> right?

Indeed, if msync() is called with MS_SYNC an explicit sync is
triggered, and Rik's suggestion would work. However, the POSIX
standard requires a call to msync() with MS_ASYNC to update the
st_ctime and st_mtime stamps too. No explicit sync of the inode data
is triggered in the current implementation of msync(). Hence Rik's
suggestion would fail to satisfy POSIX in the latter case.

>
> --
>
>  / jakob
>
>
