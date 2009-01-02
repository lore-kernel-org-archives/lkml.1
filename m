Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZABQwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZABQwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbZABQwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:52:21 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59491 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZABQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:52:20 -0500
Date: Fri, 2 Jan 2009 17:52:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, avishay@gmail.com, jeff@garzik.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       osd-dev@open-osd.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] exofs: osd Swiss army knife
Message-ID: <20090102165201.GC1555@ucw.cz>
References: <4947BFAA.4030208@panasas.com> <1229439174-30492-1-git-send-email-bharrosh@panasas.com> <20081229122959.2cb48cf7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229122959.2cb48cf7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > In this patch are all the osd infrastructure that will be used later
> > by the file system.
> > 
> > Also the declarations of constants, on disk structures, and prototypes.
> > 
> > And the Kbuild+Kconfig files needed to build the exofs module.
> > 
> >
> > ...
> >
> > +struct exofs_sb_info {
> > +	struct osd_dev	*s_dev;			/* returned by get_osd_dev    */
> > +	uint64_t	s_pid;			/* partition ID of file system*/
> > +	int		s_timeout;		/* timeout for OSD operations */
> > +	uint32_t	s_nextid;		/* highest object ID used     */
> > +	uint32_t	s_numfiles;		/* number of files on fs      */
> > +	spinlock_t	s_next_gen_lock;	/* spinlock for gen # update  */
> > +	u32		s_next_generation;	/* next gen # to use          */
> > +	atomic_t	s_curr_pending;		/* number of pending commands */
> > +	uint8_t		s_cred[OSD_CAP_LEN];	/* all-powerful credential    */
> > +};
> > +
> > +/*
> > + * our inode flags
> > + */
> > +#ifdef ARCH_HAS_ATOMIC_UNSIGNED
> 
> This doesn't exist, and it would be fairly bad to introduce it.  Please
> kill the ifdefs.
> 
> > +typedef unsigned exofs_iflags_t;
> > +#else
> > +typedef unsigned long exofs_iflags_t;
> > +#endif
> 
> Then please kill the typedef altogether and replace it with `unsigned
> long' everywhere

Hmmm.. .and at a note somewhere that we assume unsigned long to be atomic...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
