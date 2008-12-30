Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYL3L1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYL3L1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 06:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYL3L1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 06:27:14 -0500
Received: from gw.goop.org ([64.81.55.164]:49803 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbYL3L1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 06:27:14 -0500
Message-ID: <495A058C.7060105@goop.org>
Date: Tue, 30 Dec 2008 22:27:08 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
References: <49416494.6040009@goop.org> <200707241140.12945.nickpiggin@yahoo.com.au> <49470433.4050504@goop.org> <200812301442.37654.nickpiggin@yahoo.com.au>
In-Reply-To: <200812301442.37654.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> I have patches to move the tlb flushing to an asynchronous process context...
> but all tweaks to that (including flushing at vmap) are just variations on the
> existing flushing scheme and don't solve your problem, so I don't think we
> really need to change that for the moment (my patches are mainly for latency
> improvement and to allow vunmap to be usable from interrupt context).
>   

Well, that's basically what I want - I want to use vunmap in an 
interrupts-disabled context.  Any other possibility of deferring tlb 
flushes is pure bonus and not all that important.

But it also occurred to me that Xen doesn't use IPIs for cross-cpu TLB 
flushes (it goes to hypercall), so it shouldn't be an issue anyway.  I 
haven't had a chance to look at what's really going on there.

    J
