Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXDZPqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXDZPqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXDZPqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:46:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43468 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753276AbXDZPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:46:36 -0400
Date: Thu, 26 Apr 2007 08:46:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       AKPM <akpm@linux-foundation.org>
Subject: Re: [PATCH] change global zonelist order on NUMA v2
In-Reply-To: <200704261147.44413.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704260845160.1382@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
 <200704261147.44413.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andi Kleen wrote:

> On Thursday 26 April 2007 11:34:17 KAMEZAWA Hiroyuki wrote:
> > 
> > Changelog from V1 -> V2
> > - sysctl name is changed to be relaxed_zone_order
> > - NORMAL->NORMAL->....->DMA->DMA->DMA order (new ordering) is now default.
> >   NORMAL->DMA->NORMAL->DMA order (old ordering) is optional.
> > - addes boot opttion to set relaxed_zone_order. ia64 is supported now.
> > - Added documentation
> > 
> > patch is against 2.6.21-rc7-mm2. tested on ia64 NUMA box. works well.
> 
> IMHO the change should be default (without any options) unless someone
> can come up with a good reason why not. On x86-64 it should be definitely
> default.

It is not a good idea if node 0 has both DMA and NORMAL memory and normal 
memory is a small fraction of node memory. In that case lots of 
allocations get redirected to node 1.
 
> If there is a good reason on some architecture or machine a user option is also not a 
> good idea, but instead it should be set automatically by that architecture or machine
> on boot.

Right. That was my thinking.

