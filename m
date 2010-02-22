Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab0BVK5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:57:13 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56993 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0BVK5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:57:12 -0500
Message-ID: <4B826307.8030805@cs.helsinki.fi>
Date: Mon, 22 Feb 2010 12:57:11 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       rientjes@google.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org> <alpine.DEB.2.00.1002191221110.26567@router.home>
In-Reply-To: <alpine.DEB.2.00.1002191221110.26567@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter kirjoitti:
> On Mon, 15 Feb 2010, Andi Kleen wrote:
> 
>>> How, may I ask? cpuup_prepare in the hotplug notifier should always
>>> run before start_cpu_timer.
>> I'm not fully sure, but I have the oops to prove it :)
> 
> I still suspect that this has something to do with Pekka's changing the
> boot order for allocator bootstrap. Can we clarify why these problems
> exist before we try band aid?

I don't see how my changes broke things but maybe I'm not looking hard 
enough. Cache reaping is still setup from cpucache_init() which is an 
initcall which is not affected by my changes AFAICT and from 
cpuup_callback() which shoulda also not be affected.

				Pekka
