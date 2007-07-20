Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbXGTNjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbXGTNjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbXGTNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:39:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34612 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbXGTNj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:39:27 -0400
Date: Fri, 20 Jul 2007 22:39:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: mel@skynet.ie, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix memory hotplug oops from ZONE_MOVABLE changes.
Message-Id: <20070720223909.d4c1e848.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070720114246.GA27391@linux-sh.org>
References: <20070720060342.GA24765@linux-sh.org>
	<20070720112025.GA14495@skynet.ie>
	<20070720114246.GA27391@linux-sh.org>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 20:42:46 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> > I expect that the memory gets added to the same zone as historically but
> > when ZONE_MOVABLE is set, you'll see a situation where zones are overlapping
> > after memory hot-add.  i.e. Before memory hot-add, you'd see
> > 
> > DDDDMM
> > 
> > for ZONE_DMA and ZONE_MOVABLE and after hotadd, you'd see something like
> > 
> > DDDDMMDDDD
> > 

As similar case, I hear powerpc has followig memory layout

(1)(1)(0)(0)(0)(1)(1)(1)  # (0) is node 0, (1) is node 1. all zones are ZONE_DMA.

So zone is overlapped without memory hotplug.
But I agree we have to take care of this kind of corner cases.

Thanks,
-Kame
