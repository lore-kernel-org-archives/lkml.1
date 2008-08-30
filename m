Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYH3D0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYH3D0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 23:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYH3D0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 23:26:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040AbYH3D0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 23:26:04 -0400
Date: Fri, 29 Aug 2008 20:24:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808300031.16708.rjw@sisk.pl>  <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>  <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org> 
 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>  <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>  <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>
  <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org> <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Yinghai Lu wrote:
> 
> we need to use insert_resource_split_to_fit instead...
> 
> otherwise __request_region will not be happy.

Are you really really sure?

Try just removing the IORESOURCE_BUSY. As mentioned, if we expect the PCI 
BAR's to work with the e820 resources, then BUSY really is simply not 
right any more. Not that I think it should matter either..

The ones that are added _early_ should be IORESOURCE_BUSY (ie the ones 
that cover RAM), but the others we now expect to nest with PCI BARs.

But since we add them after we have parsed the BAR's, I don't even see why 
the BUSY bit should even matter - we've already added the fixed BARs, and 
any newly allocated non-fixed ones shouldn't be allocated in e820 areas 
_regardless_ of whether the BUSY bit is set or not.

So pls explain why it matters?

		Linus
