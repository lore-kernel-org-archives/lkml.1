Return-Path: <linux-kernel-owner+w=401wt.eu-S1763571AbZAUEF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763571AbZAUEF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 23:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZAUEFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:05:17 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:6252 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756279AbZAUEFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:05:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFgsdkl5LAUp/2dsb2JhbADKc4Vz
X-IronPort-AV: E=Sophos;i="4.37,298,1231075800"; 
   d="scan'208";a="272079920"
Date: Wed, 21 Jan 2009 15:05:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090121040512.GK10158@disturbed>
Mail-Followup-To: Jacek Luczak <difrost.kernel@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	LKML <linux-kernel@vger.kernel.org>,
	xfs mailing list <xfs@oss.sgi.com>
References: <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120121335.GA19182@infradead.org> <20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com> <20090120140514.GA2976@infradead.org> <4975DE45.7050004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975DE45.7050004@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 03:23:01PM +0100, Jacek Luczak wrote:
> Christoph Hellwig pisze:
> > On Tue, Jan 20, 2009 at 02:58:35PM +0100, Jacek Luczak wrote:
> >> Good job! Is there some ,,quick'' fix?
> > 
> > The patch below makes it go away for me, alternatively just enable
> > CONFIG_LBD.
> > 
> > 
> > Index: linux-2.6/fs/xfs/xfs_types.h
> > ===================================================================
> > --- linux-2.6.orig/fs/xfs/xfs_types.h	2009-01-20 14:55:55.806068213 +0100
> > +++ linux-2.6/fs/xfs/xfs_types.h	2009-01-20 14:56:01.437945154 +0100
> > @@ -96,7 +96,7 @@ typedef	__uint64_t	xfs_dfilblks_t;	/* nu
> >  /*
> >   * Memory based types are conditional.
> >   */
> > -#if XFS_BIG_BLKNOS
> > +#if 1 //XFS_BIG_BLKNOS
> >  typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
> >  typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
> >  typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
> > 
> 
> I've applied it and now running ,,fixed'' kernel. What I've notice is:
> $ LC_ALL=C df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda1              20G  -40E   40E   -  /
> /dev/sda5              20G  -23E   23E   -  /home
> /dev/sda6              56G   56G  774M  99% /NORA
> /dev/sda7              45G   44G  1.2G  98% /MAGAZYN

Please try the patch I posted this morning - it fixes the problem
properly and shouldn't have this side effect.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
