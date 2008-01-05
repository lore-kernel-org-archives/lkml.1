Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYAEUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYAEUF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYAEUFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:05:19 -0500
Received: from mga07.intel.com ([143.182.124.22]:16156 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755901AbYAEUFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:05:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,249,1196668800"; 
   d="scan'208";a="359002836"
Message-ID: <477FE25D.5070406@linux.intel.com>
Date: Sat, 05 Jan 2008 12:02:37 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com> <477F2697.5050407@goop.org> <477FC613.7020807@linux.intel.com> <477FD045.50703@goop.org>
In-Reply-To: <477FD045.50703@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Yeah, that seems reasonable if you're optimising for overall size.  Did
> you count the difference of including the function name?  We decided not
> to include it for BUG because its usefulness/size tradeoff didn't seem
> terribly important.

in the WARN_ON case it's not there either, based on Ingo's idea we do a kallsyms lookup
of __builtin_return_address(0) .. same data, less memory.


> But my goal was actually to reduce icache pollution, so by my reckoning
> code bytes were much more expensive than data ones, so putting all BUG
> information in a separate section makes those bytes much less
> significant than putting anything inline in code.  Also, the trap for
> WARN_ON would be smaller than BUG, because it wouldn't need the spurious
> infinite loop needed to make gcc understand the control flow of a BUG.
> 
> On the other hand, you could put the call to out of line warning
> function in a separate section to achieve the same effect.

yeah and gcc even has a compiler option for that. Doubt it's really worth it,
we're still talking a few bytes here ;)

> 
>     J

