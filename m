Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbYFGRMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbYFGRMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 13:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYFGRMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 13:12:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35224 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYFGRMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 13:12:39 -0400
Message-ID: <484AC165.7000702@firstfloor.org>
Date: Sat, 07 Jun 2008 19:12:05 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: don't track pages allocated with interrupts
 disabled
References: <20080607143242.GA2893@damson.getinternet.no>
In-Reply-To: <20080607143242.GA2893@damson.getinternet.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> It seems that I was wrong regarding the set_memory_4k() approach. It seems
> to only have worked because we were lucky. 

You just put it in the wrong place I think.

> We may later reinstate the code
> to disable PSE, but this time not unconditionally, perhaps with a config
> option or boot-time option.

It would be kind of guaranteed (not sure 100%) together with
CONFOG_DEBUG_PAGEALLOC and Thomas' page table pool (the pool is ifdefed
on that)

But a far better solution is to just split all the pages in  the system
with set_memory_4k() at boot time  (and memory hot add time) when you
know you're not in interrupt context.

I believe that would be the right solution for DEBUG_PAGEALLOC too.

-Andi

