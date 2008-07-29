Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYG2O62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYG2O62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYG2O6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:58:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYG2O6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:58:20 -0400
Date: Tue, 29 Jul 2008 16:58:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
Message-ID: <20080729145815.GO30344@one.firstfloor.org>
References: <488E534F.2030204@goop.org> <488E5455.6010901@goop.org> <20080729021215.GG30344@one.firstfloor.org> <488EB8BE.8050806@goop.org> <20080729120237.GH30344@one.firstfloor.org> <488F2D48.7030305@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488F2D48.7030305@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 07:46:32AM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >>Yes, but it's only held briefly to put things onto the list.  It doesn't 
> >>get held over the whole IPI transaction as the old smp_call_function 
> >>did, and the tlb flush code still does.  RCU is used to manage the list 
> >>walk and freeing, so there's no long-held locks there either.
> >>    
> >
> >If it bounces regularly it will still hurt.
> >  
> 
> We could convert smp_call_function_mask to use a multi-vector scheme 
> like tlb_64.c if that turns out to be an issue.

Converting it first would be fine. Or rather in parallel because 
you would need to reuse the TLB vectors (there are not that many 
free)

But waiting first for a report would seem wrong to me.

I can just see some poor performance person spend a lot of work to track
down such a regression. While there's a lot of development manpower available
for Linux there's still no reason to waste i. I think if you want to change 
such performance critical paths you should make sure the new code is roughly
performance equivalent first. And with the global lock I don't see that
at all.

-Andi
