Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYB0NbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYB0NbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYB0NbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:31:07 -0500
Received: from ns2.suse.de ([195.135.220.15]:43595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbYB0NbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:31:07 -0500
Message-ID: <47C5668C.6040906@suse.de>
Date: Wed, 27 Feb 2008 14:33:00 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc][patch] x86-64 new smp_call_function design
References: <20080227124217.GA1340@wotan.suse.de> <47C55FD2.8030809@suse.de> <20080227130716.GB1340@wotan.suse.de>
In-Reply-To: <20080227130716.GB1340@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> *vmalloc* TLB flushing. 
> 
> void flush_tlb_all(void)
> {
>         on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
> }
> 
> Of course we could use a new vector for it and speed it up a lot more,
> but after my vmalloc improvements I think that would be a waste of a
> vector at this point.

Ah I see sorry. If you want to just speed up vmalloc flushing I think
the easier way would be to just extend the normal TLB flusher for
vmalloc. So alone for this it probably wouldn't be worth it.

But I think it'll be useful for a couple of other things.

>>> As far as I understand, calling a subset of online CPUs that is not all or
>>> one, is used quite infrequently, so this might be OK.
>> With cpusets and isolation etc. it is the normal case.
> 
> Oh really? Coming from what callers?

The isolation work is not merged yet, but it will essentially need
to turn a lot of the _call_function()s into _call_function_mask()

-Andi


