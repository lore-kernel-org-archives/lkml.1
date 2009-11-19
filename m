Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbZKSBiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbZKSBiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 20:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbZKSBiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 20:38:09 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:46002 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757663AbZKSBiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 20:38:08 -0500
Date: Thu, 19 Nov 2009 12:38:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Dan Merillat <dan.merillat@gmail.com>,
       Tomasz Chmielewski <mangoo@wpkg.org>, preining@logic.at,
       riel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
Message-ID: <20091119013810.GO9467@discord.disaster>
References: <4B046AEA.80109@wpkg.org> <c0c067900911181640h64971680l4da14cdbe9fa6d59@mail.gmail.com> <alpine.DEB.2.00.0911190200370.32644@aurora.sdinet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911190200370.32644@aurora.sdinet.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 02:09:09AM +0100, Sven-Haegar Koch wrote:
> On Wed, 18 Nov 2009, Dan Merillat wrote:
> 
> > On Wed, Nov 18, 2009 at 4:45 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> > 
> > > I have a pretty powerful desktop machine with 8 GB RAM, fast disks with
> > > RAID-1 etc.
> > 
> > > Every 10 minutes or so, machine is really unresponsive, load jumps to 10 or
> > > 20. Mouse pointer jumps, it's impossible to change between windows etc.
> > 
> > This is the type of hefty workstation many of the core developers
> > have, running similar workloads, so I'm somewhat surprised that the
> > default VM settings have this kind of issue.
> > 
> > > Do a "swapoff -a", and everything is snappy and responsive as it should,
> > > there are no more lags.
> > 
> > Yes, that's my exact finding.
> > 
> > Is this weird IO storm happening for anyone else with plenty of memory
> > (for their taskload?)
> 
> For me it happend on my laptop. 3gb RAM, and a 1gb VMWare Windows-XP 
> instance running, plus the usual like firefox, thunderbird, kde4.
> 
> Without running vmware it did not happen. And since I have now disabled 
> barriers on the xfs /home partition (on luks crypto lvm) it also does 
> not happen anymore.

Yeah, it looks like dm-crypt recently started supporting barriers in
commit 647c7db14ef9cacc4ccb3683e206b61f0de6dc2b. Hence XFS will have
detected barriers work at mount time mount and so is now issuing
them.

Similarly, raid1 (mirror) has recently gained barrier support so
the same issue can be seen there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
