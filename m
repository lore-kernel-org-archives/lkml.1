Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbXEINzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbXEINzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXEINzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:55:47 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:57063 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbXEINzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:55:46 -0400
Subject: Re: [PATCH] change zonelist order v5 [1/3] implements zonelist
	order selection
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, ak@suse.de,
       jbarnes@virtuousgeek.org
In-Reply-To: <20070509102018.8aaf21ed.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070508201401.8f78ec37.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070508201642.c63b3f65.kamezawa.hiroyu@jp.fujitsu.com>
	 <1178643985.5203.27.camel@localhost>
	 <Pine.LNX.4.64.0705081021340.9446@schroedinger.engr.sgi.com>
	 <1178645622.5203.53.camel@localhost>
	 <Pine.LNX.4.64.0705081104180.9941@schroedinger.engr.sgi.com>
	 <1178656627.5203.84.camel@localhost>
	 <20070509092912.3140bb78.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070508175855.b126caf7.akpm@linux-foundation.org>
	 <20070509102018.8aaf21ed.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 09 May 2007 09:55:43 -0400
Message-Id: <1178718943.5047.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 10:20 +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 8 May 2007 17:58:55 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 9 May 2007 09:29:12 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Tue, 08 May 2007 16:37:06 -0400
> > > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > > 
> > > > > You probably need a 
> > > > > configuration with a couple of nodes. Maybesomething less symmetric than 
> > > > > Kame? I.e. have 4GB nodes and then DMA32 takes out a sizeable chunk of it?
> > > > > 
> > > > 
> > > > I tested on a 2 socket, 4GB Opteron blade.  All memory is either DMA32
> > > > or DMA.  I added some ad hoc instrumentation to the build_zonelist_*
> > > > functions to see what's happening.  I have verified that the patches
> > > > appear to build the zonelists correctly:
> > > > 
> > > Thank you. good news.
> > > 
> > 
> > I'm still cowering in fear of these patches, btw.
> > 
> Hmm, the patches looks unclear ? 
> 
> > Please keep testing and sending them ;)
> > 
> Okay. but it seems I need other testers...
> 
> I wonder I should drop sysctl of this patch and just support boot option
> in next version.

I think the system still need to be able to rebuild the zonelists at
run-time in response to memory hotplug [someday, maybe?].  And for now,
the sysctl is very useful for testing.  And, it does avoid a
reboot--quite expensive, timewise, on large platforms--should one find
that the default order is not appropriate.  

Lee

