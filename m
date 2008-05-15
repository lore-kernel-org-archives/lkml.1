Return-Path: <linux-kernel-owner+w=401wt.eu-S1763771AbYEOUdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763771AbYEOUdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYEOUdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:33:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35742 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYEOUdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:33:06 -0400
Message-ID: <482C9D7D.9050404@cs.helsinki.fi>
Date: Thu, 15 May 2008 23:30:53 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Christoph Lameter <clameter@sgi.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
References: <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com> <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com> <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com> <20080515181356.GP9921@parisc-linux.org> <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com> <20080515185130.GR9921@parisc-linux.org> <Pine.LNX.4.64.0805151153440.20201@schroedinger.engr.sgi.com> <20080515192959.GS9921@parisc-linux.org> <20080515201413.GT9921@parisc-linux.org>
In-Reply-To: <20080515201413.GT9921@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> This is rather interesting.  Since Christoph refuses to, here's my
> results with 8f40f67, first with slab:
> 
> Now, change the config to slub:

[snip]

> and we get slightly better results:
> 
> willy@piggy:~$ sudo ./io-gen -d /dev/sda -j4
> CPU 0 completed 1000000 ops in 45.848 seconds; 21811 ops per second
> CPU 2 completed 1000000 ops in 50.789 seconds; 19689 ops per second
> CPU 3 completed 1000000 ops in 55.876 seconds; 17896 ops per second
> CPU 1 completed 1000000 ops in 56.941 seconds; 17562 ops per second
> willy@piggy:~$ sudo taskset -p 1 1001
> pid 1001's current affinity mask: f
> pid 1001's new affinity mask: 1
> willy@piggy:~$ sudo ./io-gen -d /dev/sda -j4
> CPU 2 completed 1000000 ops in 45.713 seconds; 21875 ops per second
> CPU 0 completed 1000000 ops in 47.020 seconds; 21267 ops per second
> CPU 3 completed 1000000 ops in 58.692 seconds; 17038 ops per second
> CPU 1 completed 1000000 ops in 60.389 seconds; 16559 ops per second

Slabinfo -A -r before and after the run would be nice (you 
CONFIG_SLUB_STATS and Documentation/vm/slabinfo.c for the latter). A 
separate oprofile would be nice as well. Thanks!

		Pekka
