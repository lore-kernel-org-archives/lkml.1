Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbYLLSTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbYLLSTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbYLLSTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:19:11 -0500
Received: from brick.kernel.dk ([93.163.65.50]:6482 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbYLLSTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:19:10 -0500
Date: Fri, 12 Dec 2008 19:18:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Message-ID: <20081212181850.GJ23742@kernel.dk>
References: <20081211111614.493d2a62@hyperion.delvare> <20081211104109.GF23742@kernel.dk> <20081211115844.1b1dbf49@hyperion.delvare> <20081211110839.GH23742@kernel.dk> <20081211134438.6d871834@hyperion.delvare> <20081211125000.GL23742@kernel.dk> <20081212084850.1b56529f@hyperion.delvare> <20081212075431.GG23742@kernel.dk> <20081212104154.0206d8a9@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212104154.0206d8a9@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12 2008, Jean Delvare wrote:
> > diff --git a/include/linux/types.h b/include/linux/types.h
> > index 1d98330..121f349 100644
> > --- a/include/linux/types.h
> > +++ b/include/linux/types.h
> > @@ -135,19 +135,14 @@ typedef		__s64		int64_t;
> >   *
> >   * Linux always considers sectors to be 512 bytes long independently
> >   * of the devices real block size.
> > + *
> > + * blkcnt_t is the type of the inode's block count.
> >   */
> 
> You might want to edit the start of this comment a bit, as it currently
> says "The type used for...". You probably want instead "sector_t is the
> type...". And drop the extra "*" while you're here, as this is a
> regular comment and not a kerneldoc thing.

Agree, that'll make it cleaner. I'll make those changes next time I have
to shuffle the patches.

> >  #ifdef CONFIG_LBD
> >  typedef u64 sector_t;
> > -#else
> > -typedef unsigned long sector_t;
> > -#endif
> > -
> > -/*
> > - * The type of the inode's block count.
> > - */
> > -#ifdef CONFIG_LSF
> >  typedef u64 blkcnt_t;
> >  #else
> > +typedef unsigned long sector_t;
> >  typedef unsigned long blkcnt_t;
> >  #endif
> >  
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>

Thanks, I added your Acked-by.

-- 
Jens Axboe

