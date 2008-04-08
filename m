Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYDHIH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYDHIH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYDHIHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:07:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39387 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYDHIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:07:43 -0400
Date: Tue, 8 Apr 2008 10:12:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: bootmem allocator
Message-ID: <20080408081206.GL16647@one.firstfloor.org>
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu> <87iqytqwl7.fsf@basil.nowhere.org> <20080408080446.GA12308@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408080446.GA12308@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 10:04:46AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > hm, bootmem allocator is supposed to clear memory. We have a couple 
> > > of places that rely on that.
> > 
> > I was actually considering to change that for the GB pages hugetlbfs 
> > patchkit, because memset for 1G is a little slow and not needed (will 
> > be cleared later anyways) and it might be a problem for very large 
> > systems with a lot of such pages at boot.
> 
> changing the default behavior of bootmem alloc to be non-clearing is a 
> really bad idea that will only cause unrobustness. The proper approach 
> is to add an _opt-in_ API that does not clear memory 

I was considering that too, but we have so many weird variants of bootmem
with opt in and opt out and even combinations of both now that the whole thing 
is starting to look really pear shaped (I admit I added some of them
in the past myself but I'm not proud). Would be a great project for
someone to consolidate that all a bit.

-Andi

