Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXDDSoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXDDSoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXDDSoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:44:08 -0400
Received: from iasrv1.idleaire.net ([63.78.244.180]:32833 "EHLO
	iasrv1.idleaire.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbXDDSoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:44:05 -0400
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 14:44:05 EDT
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
From: Dave Dillow <dave@thedillows.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org,
       amanda-hackers@amanda.org, amanda-users@amanda.org
In-Reply-To: <20070404104219.40e25b6a.akpm@linux-foundation.org>
References: <200704010100.19016.gene.heskett@verizon.net>
	 <2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com>
	 <200704011141.53105.gene.heskett@verizon.net>
	 <200704020021.02393.gene.heskett@gmail.com>
	 <1175488272.3161.28.camel@obelisk.thedillows.org>
	 <1175661256.31439.23.camel@obelisk.thedillows.org>
	 <20070404084530.GB1556@elte.hu>
	 <20070404104219.40e25b6a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 14:17:13 -0400
Message-Id: <1175710634.27756.40.camel@dillow.idleaire.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2007 18:16:38.0788 (UTC) FILETIME=[633D0440:01C776E5]
X-TM-AS-Product-Ver: SMEX-7.0.0.1345-3.6.1039-14858.000
X-TM-AS-Result: No--11.931800-8.000000-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 10:42 -0700, Andrew Morton wrote:
> On Wed, 4 Apr 2007 10:45:30 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Dave Dillow <dave@thedillows.org> wrote:
> > 
> > > > Then it is a matter of figuring out why the device number changed -- 
> > > > I'm thinking it is device-mapper, but will look closer tomorrow.
> > > 
> > > This commit is the one that changed it:
> > > 
> > > commit fdf892be32d84a1745fa0aee5fc60517421b8038
> > > Author: Andrew Morton <akpm@osdl.org>
> > > Date:   Mon Feb 12 00:51:44 2007 -0800
> > > 
> > >     [PATCH] register_blkdev(): don't hand out the LOCAL/EXPERIMENTAL majors
> > >     
> > >     As pointed out in http://bugzilla.kernel.org/show_bug.cgi?id=7922, 
> > >     dynamic blockdev major allocation can hand out majors which LANANA 
> > >     has defined as being for local/experimental use.
> > 
> > i dont think we should break backwards compatibility with a system that 
> > has not changed any hardware. Andrew, should we revert this?
> 
> Well that's an odd thing for a backup program to be doing - there are any
> number of things which could cause a dynamically-allocated major to change.
> 
> ho hum, yes, I guess it needs to go.

The thing is, it's been broken for a long time -- this change just
highlighted it. This isn't the first time that device-mapper has moved
-- the introduction of mdp (before git, so haven't tracked down
timeframe) also moved it around. The dynamic major is not stable, so
should we be concerned if it moves for 2.6.21?

I don't like the effect it has on the backups, but I don't think we
should hand out LOCAL/EXP majors to dynamic devices, either. There is a
module option to make the device-mapper and mdp majors stable, so
perhaps a compromise is possible? Revert for 2.6.21, and schedule the
patch for later addition, which gives distros time to use the DM major
option?
-- 
Dave Dillow <dave@thedillows.org>

