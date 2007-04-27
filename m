Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbXD0AlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbXD0AlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbXD0AlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:41:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41377 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbXD0AlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:41:15 -0400
Date: Fri, 27 Apr 2007 09:41:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, clameter@sgi.com, ak@suse.de
Subject: Re: [PATCH] change global zonelist order on NUMA v2
Message-Id: <20070427094141.82b16497.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1177624660.5705.72.camel@localhost>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
	<1177624660.5705.72.camel@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 17:57:40 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Thu, 2007-04-26 at 18:34 +0900, KAMEZAWA Hiroyuki wrote:
> > Changelog from V1 -> V2
> > - sysctl name is changed to be relaxed_zone_order
> > - NORMAL->NORMAL->....->DMA->DMA->DMA order (new ordering) is now default.
> >   NORMAL->DMA->NORMAL->DMA order (old ordering) is optional.
> > - addes boot opttion to set relaxed_zone_order. ia64 is supported now.
> > - Added documentation
> > 
> > patch is against 2.6.21-rc7-mm2. tested on ia64 NUMA box. works well.
> 
> [PATCH] factor/rework change zonelist order patch
> 
> Against 2.6.21-rc7 atop KAMEZAWA Hiroyuki's "change global zonelist
> order on NUMA v2" patch.
> 
Hi, this looks 'easier-to-read' than mine. thanks.


> 3) kept early_param() definition for boot parameter in mm/page_alloc.c,
>    along with the handler function.  One less file to modify.
> 
I put early_param() to arch dependent part just beacause no generic code
except for pci seems to call it. If it is allowed, I welcome this change.


> 4) modified the two Documentation additions to match these changes.
> 

> I've tested various combinations [non-exhaustive], with an ad hoc
> instrumentation patch, and it appears to work as expected [as I expect,
> anyway] on ia64 NUMA.
> 
> Question:  do we need to rebuild the zonelist caches when we reorder
>            the zones?  The z_to_n[] array appears to be dependent on
>            the zonelist order... 
> 
maybe no.


> Also:      I see the "Movable" zones show up in 21-rc7-mm2.  This patch
>            will cause Movable zone to overflow to remote movable zones
>            before using local Normal memory in non-default, zone order.
>            Is this what we want?
> 
>From my point of view, it's what I want. What we have to do will be
establish a way to create ZONE_MOVABLE with suitable size on each node.

I'll merge your change to my set and add "automatic detection" support.

Thank you.
-Kame

