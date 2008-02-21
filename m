Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbYBUPuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbYBUPuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYBUPug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:50:36 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53209 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYBUPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:50:35 -0500
Date: Thu, 21 Feb 2008 17:49:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Glenn Streiff <gstreiff@NetEffect.com>
Cc: Roland Dreier <rdreier@cisco.com>, Faisal Latif <flatif@NetEffect.com>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix
	off-by-one
Message-ID: <20080221154951.GA28328@cs181133002.pp.htv.fi>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 06:39:45AM -0600, Glenn Streiff wrote:
> 
> > >  > No, 51af33e8 was for a similar same bug 400 lines below 
> > this bug...
> > > 
> > > Heh, sorry.
> > > 
> > > Glenn -- please review Adrian's patches and let me know 
> > which ones are
> > > good to apply.
> > > 
> > 
> 
> I went ahead and created a patch series and attributed Adrian
> for the patches of his I liked.  There were a couple that
> I tweaked.  Wasn't sure if all the hunks would apply nicely
> after that if we mixed and matched his and mine, hence the series.
> 
> Hope that's okay.  Should I have gotten his ack for the ones
> I rewrote?  The fixes were pretty small so I figured they didn't
> really need more review.
>...

Looking at the patches what you did seems OK.


But regarding "review" I have a different criticism directed at Roland:

This driver should really have gotten some review before being included 
in the kernel.

Even a simple checkpatch run finds more than > 250 stylistic errors
(not code bugs but cases where the driver violates the standard code 
formatting rules of kernel code).

And I'm not talking about the > 2000 checkpatch warnings that are mostly 
about too long lines (which should arguably also be fixed).

And many more issues that could have been foung during a review.
E.g. when you look at 3/8 from this series the code
        if (!cm_node)
                return -EINVAL;
        new_send = kzalloc(sizeof(*new_send), GFP_ATOMIC);
        if (!new_send)
                return -1;
doesn't look good since the -1 should most likely better be something 
like -ENOMEM (I haven't checked whether you can immediately change it 
at this specific place).

And these are just comments from someone with zero knowledge about 
InfiniBand, but I'd expect InfiniBand-specifig bugs might be found 
before they hit users if an InfiniBand maintainer would review the 
complete driver.

Note that this is not meant as a criticism against Glenn - it's 
normal that submitted code contains bugs, but a code review can help to 
cope with this.

> Glenn

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

