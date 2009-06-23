Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbZFWN7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbZFWN7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbZFWN7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:59:46 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:43334
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756833AbZFWN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:59:46 -0400
X-IronPort-AV: E=Sophos;i="4.42,275,1243807200"; 
   d="scan'208";a="42282174"
Message-ID: <4A40DFF5.7010207@inria.fr>
Date: Tue, 23 Jun 2009 16:00:21 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu> <20090623134749.GA6897@elte.hu>
In-Reply-To: <20090623134749.GA6897@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>  $ perf stat -e cycles -e instructions -e r1000ffe0 ./hackbench 10
>>  Time: 0.186
>>     
>
> Correction: that should be r10000ffe0.
>   

Oh thanks a lot, it seems to work now!

One strange thing I noticed: sometimes perf reports that there were some
accesses to target numa nodes 4-7 while my box only has 4 numa nodes:
If I request counters only for the non-existing target numa nodes (4-7,
with -e r1000010e0 -e r1000020e0 -e r1000040e0 -e r1000080e0), I always
get 4 zeros.
But if I mix some couinters from the existing nodes (0-3) with some
counters from non-existing nodes (4-7), the non-existing ones report
some small but non-empty values.
Does it ring any bell?

Brice

