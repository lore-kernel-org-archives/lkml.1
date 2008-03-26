Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYCZA0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYCZA0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYCZA0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:26:24 -0400
Received: from lemon.ertos.nicta.com.au ([203.143.174.143]:49313 "EHLO
	lemon.gelato.unsw.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbYCZA0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:26:24 -0400
X-Greylist: delayed 2659 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 20:26:23 EDT
Date: Wed, 26 Mar 2008 11:25:58 +1100
Message-ID: <87od925o15.wl%peter@chubb.wattle.id.au>
From: Peter Chubb <peterc@gelato.unsw.edu.au>
To: David Miller <davem@davemloft.net>
Cc: peterc@gelato.unsw.edu.au, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org, ianw@gelato.unsw.edu.au
In-Reply-To: <20080325.164927.249210766.davem@davemloft.net>
References: <Pine.LNX.4.64.0803251045510.16206@schroedinger.engr.sgi.com>
	<20080325.162244.61337214.davem@davemloft.net>
	<87tziu5q37.wl%peter@chubb.wattle.id.au>
	<20080325.164927.249210766.davem@davemloft.net>
User-Agent: Wanderlust/2.15.6 (Almost Unreal) SEMI/1.14.6 (Maruoka) FLIM/1.14.9 (Goj~) APEL/10.7 MULE XEmacs/21.4 (patch 20) (Double Solitaire) (i486-linux-gnu)
Organization: Gelato@UNSW
X-SA-Exim-Connect-IP: 203.143.174.121
X-SA-Exim-Mail-From: peterc@gelato.unsw.edu.au
Subject: Re: larger default page sizes...
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:39:27 +0000)
X-SA-Exim-Scanned: Yes (on lemon.gelato.unsw.edu.au)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "David" == David Miller <davem@davemloft.net> writes:

David> From: Peter Chubb <peterc@gelato.unsw.edu.au> Date: Wed, 26 Mar
David> 2008 10:41:32 +1100

>> It's actually harder than it looks.  Ian Wienand just finished his
>> Master's project in this area, so we have *lots* of data.  The main
>> issue is that, at least on Itanium, you have to turn off the
>> hardware page table walker for hugepages if you want to mix
>> superpages and standard pages in the same region. (The long format
>> VHPT isn't the panacea we'd like it to be because the hash function
>> it uses depends on the page size).  This means that although you
>> have fewer TLB misses with larger pages, the cost of those TLB
>> misses is three to four times higher than with the standard pages.

David> If the hugepage is more than 3 to 4 times larger than the base
David> page size, which it almost certainly is, it's still an enormous
David> win.

That depends on the access pattern.  We measured a small win for some
workloads, and a small loss for others, using 4k base pages, and
allowing up to 4G superpages (the actual sizes used depended on the
size of the objects being allocated, and the amount of contiguous
memory available).

--
Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
