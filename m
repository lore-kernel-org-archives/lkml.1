Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXD0A1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXD0A1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbXD0A1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:27:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39546 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbXD0A1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:27:35 -0400
Date: Fri, 27 Apr 2007 09:27:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] change global zonelist order on NUMA v2
Message-Id: <20070427092736.d0626a30.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704260846590.1382@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
	<200704261147.44413.ak@suse.de>
	<20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0704260846590.1382@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 08:48:19 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 26 Apr 2007, KAMEZAWA Hiroyuki wrote:
> 
> > (1)Use new zonelist ordering always and move init_task's tied cpu to a
> >   cpu on the best node. 
> >   Child processes will start in good nodes even if Node 0 has small memory.
> 
> How about renumbering the nodes? Node 0 is the one with no DMA memory and 
> node 1 may be the one with the DMA? That would take care of things even 
> without core modifications. We can start on node 0 (which hardware 1) and 
> consume the required memory for boot there not impacting the node with the 
> DMA memory.
> 
It seems a bit complicated. If we do so, following can occur,

Node1: cpu0,1,2,3
Node0: cpu4,5,6,7

the system layout will be not imaginable look, maybe.

-Kame

