Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYHSHoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYHSHoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYHSHoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:44:06 -0400
Received: from gw.goop.org ([64.81.55.164]:39802 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYHSHoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:44:06 -0400
Message-ID: <48AA79C4.8060309@goop.org>
Date: Tue, 19 Aug 2008 00:44:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
 to use function calls [POST 2]
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu> <20080819073214.GD9807@one.firstfloor.org>
In-Reply-To: <20080819073214.GD9807@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> nice stuff!
>>     
>
> If only those 35% wouldn't be there ...
>   

Don't pay attention to that number.  It's only the extra latency of a HT
context->HT context function call + tlb flush.  Which means 1) the tlb
is shared anyway, so the extra flush is redundant, 2) they're not really
concurrent, 3) it's going down the single-cpu call, rather than the
multi-cpu one, 4) it's only measuring the latency for a particular tlb
flush, and doesn't take into account any throughput improvements the
extra queueing may add.

I don't really know what the nett consequence of all that is, but it
means the number has almost no bearing on multicore results, esp with >2
cores.

    J
