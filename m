Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbXBXFyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbXBXFyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 00:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbXBXFyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 00:54:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49144
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbXBXFyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 00:54:40 -0500
Date: Fri, 23 Feb 2007 21:54:39 -0800 (PST)
Message-Id: <20070223.215439.92580943.davem@davemloft.net>
To: clameter@engr.sgi.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, andi@firstfloor.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: The unqueued Slab allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702232145340.1872@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702221040140.2011@schroedinger.engr.sgi.com>
	<20070224142835.4c7a3207.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702232145340.1872@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@engr.sgi.com>
Date: Fri, 23 Feb 2007 21:47:36 -0800 (PST)

> On Sat, 24 Feb 2007, KAMEZAWA Hiroyuki wrote:
> 
> > >From a viewpoint of a crash dump user, this merging will make crash dump
> > investigation very very very difficult.
> 
> The general caches already merge lots of users depending on their sizes. 
> So we already have the situation and we have tools to deal with it.

But this doesn't happen for things like biovecs, and that will
make debugging painful.

If a crash happens because of a corrupted biovec-256 I want to know
it was a biovec not some anonymous clone of kmalloc256.

Please provide at a minimum a way to turn the merging off.

I also agree with Andi in that merging could mess up how object type
local lifetimes help reduce fragmentation in object pools.

