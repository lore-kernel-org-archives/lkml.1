Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbZLOLLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbZLOLLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759687AbZLOLLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:11:45 -0500
Received: from sh.osrg.net ([192.16.179.4]:42167 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZLOLLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:11:44 -0500
Date: Tue, 15 Dec 2009 20:10:48 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, yinghai@kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org
Subject: Re: bisected crash due to "x86: Move swiotlb initialization before
 dma32_free_bootmem"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091215105650.GA13214@elte.hu>
References: <4B2752A9.10903@kernel.org>
	<20091215182243R.fujita.tomonori@lab.ntt.co.jp>
	<20091215105650.GA13214@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091215201039V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 15 Dec 2009 20:10:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 11:56:50 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > There are a few people who hit this. How many people use a box with over 
> > 256GB memory?
> > 
> > And you can work around this with "dma32_size" kernel boot option.
> 
> Well, since the kernel has not crashed before this change there's really just 
> two options as per upstream kernel regression policy: either we fix it or we 
> revert it.

As I wrote, here is a patch that can be applied to cleanly to the git
head:

http://www.kernel.org/pub/linux/kernel/people/tomo/misc/0001-x86-two-stage-swiotlb-initialization.patch

It fixes the problem. Yinghai, can you test it? It should work but
it's good to confirm it.

I simply wanted to say that it's not a bug that breaks lots of boxes
or leads to something serious like data corruption (no need to say
something like "revert it now!"). It's also worth investigating why it
breaks, I think.
