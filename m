Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXDZKKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXDZKKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030367AbXDZKKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:10:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42930 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030346AbXDZKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:10:11 -0400
Date: Thu, 26 Apr 2007 19:10:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, clameter@sgi.com
Subject: Re: [PATCH] change global zonelist order on NUMA v2
Message-Id: <20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200704261147.44413.ak@suse.de>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
	<200704261147.44413.ak@suse.de>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 11:47:44 +0200
Andi Kleen <ak@suse.de> wrote:

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
> 
> If there is a good reason on some architecture or machine a user option is also not a 
> good idea, but instead it should be set automatically by that architecture or machine
> on boot.
> 
Hmm...sounds reasonable. 

I have 2 idea for automatic way..

(1)Use new zonelist ordering always and move init_task's tied cpu to a
  cpu on the best node. 
  Child processes will start in good nodes even if Node 0 has small memory.

(2) Set Node's local highest zone to the top of zonelist.

I like (1). Does anyone have an idea ?

-Kame

