Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859Ab0BZBNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:13:21 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40959 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934840Ab0BZBNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:13:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Feb 2010 10:09:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-Id: <20100226100944.1c2aa738.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002251228140.18861@router.home>
References: <20100211953.850854588@firstfloor.org>
	<20100211205404.085FEB1978@basil.firstfloor.org>
	<20100215061535.GI5723@laptop>
	<20100215103250.GD21783@one.firstfloor.org>
	<20100215104135.GM5723@laptop>
	<20100215105253.GE21783@one.firstfloor.org>
	<20100215110135.GN5723@laptop>
	<alpine.DEB.2.00.1002191222320.26567@router.home>
	<20100220090154.GB11287@basil.fritz.box>
	<alpine.DEB.2.00.1002240949140.26771@router.home>
	<4B862623.5090608@cs.helsinki.fi>
	<alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002251228140.18861@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010 12:30:26 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 25 Feb 2010, David Rientjes wrote:
> 
> > I don't see how memory hotadd with a new node being onlined could have
> > worked fine before since slab lacked any memory hotplug notifier until
> > Andi just added it.
> 
> AFAICR The cpu notifier took on that role in the past.
> 
> If what you say is true then memory hotplug has never worked before.
> Kamesan?
> 
In this code,

 int node = numa_node_id();

node is got by its CPU.

At node hotplug, following order should be kept.
	Add:   memory -> cpu
	Remove: cpu -> memory

cpus must be onlined after memory. At least, we online cpus only after
memory. Then, we(our heavy test on RHEL5) never see this kind of race.


I'm sorry if my answer misses your point.

Thanks,
-Kame
 

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

