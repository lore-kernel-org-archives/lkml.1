Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbYGAQgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbYGAQgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYGAQgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:36:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbYGAQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:36:12 -0400
Date: Tue, 1 Jul 2008 09:35:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
cc: Hideo Saito <saito@densan.co.jp>, linux-sh@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: follow_page() performance regressions
In-Reply-To: <alpine.LFD.1.10.0807010837510.20870@hp.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807010933180.20870@hp.linux-foundation.org>
References: <20080701.132439.68562265.saito@densan.co.jp> <20080701052543.GA4726@linux-sh.org> <alpine.LFD.1.10.0807010837510.20870@hp.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jul 2008, Linus Torvalds wrote:
> 
>  - some cache issue on SH. ZERO_PAGE is a single page at a fixed virtual 
>    address, while it used to populate the page tables with individual 
>    pages. Normally, this should be *better* for caching, but maybe there 
>    is some conflict? What kind of caches does SH have (virtually indexed?)

Actually, this one is unlikely. ZERO_PAGE _used_ to be problematic on some 
virtually indexed caches, because the same physical page would get mapped 
into multiple places virtually, which in turn then caused some cache or 
TLB conflict or something (I forget - MIPS was the main offender).

But because we now use just the single kernel virtual address for 
accessing the ZERO_PAGE, that really shouldn't matter. Unless the 
particular user of follow_pages() that triggers in this case is doing 
something odd, of course.

		Linus
