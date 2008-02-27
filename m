Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYB0NCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYB0NCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbYB0NC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:02:27 -0500
Received: from mail.suse.de ([195.135.220.2]:37123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbYB0NC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:02:26 -0500
Message-ID: <47C55FD2.8030809@suse.de>
Date: Wed, 27 Feb 2008 14:04:18 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc][patch] x86-64 new smp_call_function design
References: <20080227124217.GA1340@wotan.suse.de>
In-Reply-To: <20080227124217.GA1340@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On a 2 socket, 8 core system, I see anywhere up to nearly 16x better
> performance on a stress test. The common cases of call-all, and wait
> are improved the least, however I think that if call-single and nowait
> are turned into a high performance API, then new usages will pop up
> (eg. I started this because I wanted to do "call single, nowait" calls
> for migrating block IO completions back to submitting CPU; however I
> am also interested in improving the "call all, wait" case for example
> to improve vmalloc tlb flushing).

TLB flushing at least on x86-64 should be already well optimized on its
own. I would be surprised if you could do much better.

> As far as I understand, calling a subset of online CPUs that is not all or
> one, is used quite infrequently, so this might be OK.

With cpusets and isolation etc. it is the normal case.

-Andi
