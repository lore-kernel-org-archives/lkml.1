Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYAJIvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYAJIvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYAJIvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:51:22 -0500
Received: from unthought.net ([212.97.129.88]:57656 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbYAJIvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:51:22 -0500
Date: Thu, 10 Jan 2008 09:51:20 +0100
From: Jakob Oestergaard <jakob@unthought.net>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Valdis.Kletnieks@vt.edu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Message-ID: <20080110085120.GK25527@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	Anton Salikhmetov <salikhmetov@gmail.com>,
	Rik van Riel <riel@redhat.com>, Valdis.Kletnieks@vt.edu,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1199728459.26463.11.camel@codedot> <20080109155015.4d2d4c1d@cuia.boston.redhat.com> <26932.1199912777@turing-police.cc.vt.edu> <20080109170633.292644dc@cuia.boston.redhat.com> <20080109223340.GH25527@unthought.net> <20080109184141.287189b8@bree.surriel.com> <4df4ef0c0801091603y2bf507e1q2b99971c6028d1f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4df4ef0c0801091603y2bf507e1q2b99971c6028d1f3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 03:03:03AM +0300, Anton Salikhmetov wrote:
...
> > I guess a third possible time (if we want to minimize the number of
> > updates) would be when natural syncing of the file data to disk, by
> > other things in the VM, would be about to clear the I_DIRTY_PAGES
> > flag on the inode.  That way we do not need to remember any special
> > "we already flushed all dirty data, but we have not updated the mtime
> > and ctime yet" state.
> >
> > Does this sound reasonable?
> 
> No, it doesn't. The msync() system call called with the MS_ASYNC flag
> should (the POSIX standard requires that) update the st_ctime and
> st_mtime stamps in the same manner as for the MS_SYNC flag. However,
> the current implementation of msync() doesn't call the do_fsync()
> function for the MS_ASYNC case. The msync() function may be called
> with the MS_ASYNC flag before "natural syncing".

If the update was done as Rik suggested, with the addition that msync()
triggered an explicit sync of the inode data, then everything would be ok,
right?

-- 

 / jakob

