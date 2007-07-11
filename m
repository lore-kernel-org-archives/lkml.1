Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXGKLZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXGKLZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXGKLZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:25:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60940 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbXGKLZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:25:10 -0400
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Jackson <pj@sgi.com>
Cc: vatsa@linux.vnet.ibm.com, mingo@elte.hu, akpm@linux-foundation.org,
       menage@google.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-Reply-To: <20070711041007.10ad759c.pj@sgi.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070710105240.GA20914@linux.vnet.ibm.com>
	 <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	 <20070710115319.0bdaff34.akpm@linux-foundation.org>
	 <20070711045516.GH2927@linux.vnet.ibm.com>
	 <20070710222942.382fc9ba.akpm@linux-foundation.org>
	 <20070711090423.GA6758@elte.hu> <20070711022352.71604404.pj@sgi.com>
	 <20070711100323.GA23473@linux.vnet.ibm.com>
	 <20070711041007.10ad759c.pj@sgi.com>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 13:24:47 +0200
Message-Id: <1184153087.20032.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 04:10 -0700, Paul Jackson wrote:
> Srivatsa wrote:
> > So Ingo was proposing we use cpuset as that user interface to manage
> > task-groups. This will be only for 2.6.23.
> 
> Good explanation - thanks.
> 
> In short, the proposal was to use the task partition defined by cpusets
> to define CFS task-groups, until the real process containers are
> available.
> 
> Or, I see in the next message, Ingo responding favorably to your
> alternative, using task uid's to partition the tasks into CFS
> task-groups.
> 
> Yeah, Ingo's preference for using uid's (or gid's ??) sounds right to
> me - a sustainable API.
> 
> Wouldn't want to be adding a cpuset API for a single 2.6.N release.
> 
> .... gid's -- why not?


Or process or process groups, or all of the above :-)

One thing to think on though, we cannot have per process,uid,gid,pgrp
scheduling for one release only. So we'd have to manage interaction with
process containers. It might be that a simple weight multiplication
scheme is good enough:

  weight = uid_weight * pgrp_weight * container_weight

Of course, if we'd only have a single level group scheduler (as was
proposed IIRC) it'd have to create intersection sets (as there might be
non trivial overlaps) based on these various weights and schedule these
resulting sets instead of the initial groupings.


