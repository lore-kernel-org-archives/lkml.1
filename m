Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbXLRVsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbXLRVsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbXLRVsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:48:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926AbXLRVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:48:08 -0500
Date: Tue, 18 Dec 2007 13:46:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <20071219002349.A12278@jurassic.park.msu.ru>
Message-ID: <alpine.LFD.0.9999.0712181338150.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net>
 <20071219002349.A12278@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Dec 2007, Ivan Kokshaysky wrote:
> 
> Doh. Let's fix the kernel first...
> 
> Does this make any difference? (the patch is self explaining ;-)

Heh, indeed. Good catch - that

	Prefetchable memory behind bridge: 0000000000000000-000000000fffffff

on device 00:01.0 does look totally broken, and it would make more sense 
if it matched what the device has (and what /proc/iomem resports).

That said, Intel bridges tend to be transparent even when they *claim* 
normal decode, so I wonder whether it actually matters in this case. But 
your patch looks very obviously right. 

So maybe the rest of the kernel and X both already did everything right, 
and it was just this stupid bridge setup thing that was broken (and 
forcing the IOMEM resource to below the 4G mark just hid it).

			Linus
