Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbXIDTXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbXIDTXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 15:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbXIDTXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 15:23:08 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:35400 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752310AbXIDTXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 15:23:07 -0400
X-YMail-OSG: zKag274VM1kmg7KWO4UvnsoPOyd9YTOrhwYqOcP1k8su2.A0RErOsF3uyz.u88gs6LkXSrLuAnkck_EWw_5lkdAl.A--
X-RocketYMMF: knobi.rm
Date: Tue, 4 Sep 2007 12:23:04 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: knobi@knobisoft.de
Subject: Re: huge improvement with per-device dirty throttling
To: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>,
       linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Peter zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <46DD2760.3040505@wldelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <713371.64716.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Leroy van Logchem <leroy.vanlogchem@wldelft.nl> wrote:

> Andrea Arcangeli wrote:
> > On Wed, Aug 22, 2007 at 01:05:13PM +0200, Andi Kleen wrote:
> >> Ok perhaps the new adaptive dirty limits helps your single disk
> >> a lot too. But your improvements seem to be more "collateral
> damage" @)
> >>
> >> But if that was true it might be enough to just change the dirty
> limits
> >> to get the same effect on your system. You might want to play with
> >> /proc/sys/vm/dirty_*
> > 
> > The adaptive dirty limit is per task so it can't be reproduced with
> > global sysctl. It made quite some difference when I researched into
> it
> > in function of time. This isn't in function of time but it
> certainly
> > makes a lot of difference too, actually it's the most important
> part
> > of the patchset for most people, the rest is for the corner cases
> that
> > aren't handled right currently (writing to a slow device with
> > writeback cache has always been hanging the whole thing).
> 
> 
> Self-tuning > static sysctl's. The last years we needed to use very 
> small values for dirty_ratio and dirty_background_ratio to soften the
> 
> latency problems we have during sustained writes. Imo these patches 
> really help in many cases, please commit to mainline.
> 
> -- 
> Leroy
> 

 while it helps in some situations, I did some tests today with
2.6.22.6+bdi-v9 (Peter was so kind) which seem to indicate that it
hurts NFS writes. Anyone seen similar effects?

 Otherwise I would just second your request. It definitely helps the
problematic performance of my CCISS based RAID5 volume.

Martin

Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
