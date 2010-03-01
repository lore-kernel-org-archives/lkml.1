Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0CACDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 21:03:14 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54321 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0CACDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 21:03:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 1 Mar 2010 10:59:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-Id: <20100301105932.5db60c93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100226173115.GG16335@basil.fritz.box>
References: <alpine.DEB.2.00.1002191222320.26567@router.home>
	<20100220090154.GB11287@basil.fritz.box>
	<alpine.DEB.2.00.1002240949140.26771@router.home>
	<4B862623.5090608@cs.helsinki.fi>
	<alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002251228140.18861@router.home>
	<20100226114136.GA16335@basil.fritz.box>
	<alpine.DEB.2.00.1002260904311.6641@router.home>
	<20100226155755.GE16335@basil.fritz.box>
	<alpine.DEB.2.00.1002261123520.7719@router.home>
	<20100226173115.GG16335@basil.fritz.box>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 18:31:15 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, Feb 26, 2010 at 11:24:50AM -0600, Christoph Lameter wrote:
> > On Fri, 26 Feb 2010, Andi Kleen wrote:
> > 
> > > > > Memory hotplug with node add never quite worked on x86 before,
> > > > > for various reasons not related to slab.
> > > >
> > > > Ok but why did things break in such a big way?
> > >
> > > 1) numa memory hotadd never worked
> > 
> > Well Kamesan indicated that this worked if a cpu became online.
> 
> I mean in the general case. There were tons of problems all over.
> 
Then, it's cpu hotplug matter, not memory hotplug.
cpu hotplug callback should prepaare 


	l3 = searchp->nodelists[node];
	BUG_ON(!l3);

before onlined. Rather than taking care of races.


Thanks,
-Kame

