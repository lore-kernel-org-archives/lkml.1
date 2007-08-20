Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbXHTIjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbXHTIjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXHTIjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:39:17 -0400
Received: from [203.171.70.205] ([203.171.70.205]:60137 "EHLO
	home.nigel.suspend2.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbXHTIjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:39:16 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Should GFP_ATOMIC fail when we're below low watermark?
Date: Mon, 20 Aug 2007 18:38:48 +1000
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200708201138.50508.nigel@nigel.suspend2.net> <1187577830.6114.140.camel@twins>
In-Reply-To: <1187577830.6114.140.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708201838.50262.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Monday 20 August 2007 12:43:50 Peter Zijlstra wrote:
> On Mon, 2007-08-20 at 11:38 +1000, Nigel Cunningham wrote:
> > Hi all.
> > 
> > In current git (and for a while now), an attempt to allocate memory with 
> > GFP_ATOMIC will fail if we're below the low watermark level. The only way 
to 
> > access that memory that I can see (not that I've looked that hard) is to 
have 
> > PF_MEMALLOC set (ie from kswapd). I'm wondering if this behaviour is 
correct. 
> > Shouldn't GFP_ATOMIC allocations ignore watermarks too? How about 
GFP_KERNEL?
> > 
> > The following patch is a potential fix for GFP_ATOMIC.
> 
> Sorry, no.
> 
> GFP_ATOMIC must fail when below the watermark. GFP_KERNEL has __GFP_WAIT
> and hence can sleep and wait for reclaim so that should not be a problem
> (usually).
> 
> GFP_ATOMIC may not access the reserves because the reserves are needed
> to get out of OOM deadlocks within the VM. Consider the fact that
> freeing memory needs memory - if there is no memory free, you cannot
> free memory and you're pretty much stuck.

I guess, then, the question should be whether the watermark values are 
appropriate. Do we need high order allocations watermarked if this is the 
only purpose, particularly considering that whatever memory is allocated for 
this purpose is essentially useless 99.9% of the time?

Regards,

Nigel
-- 
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.
