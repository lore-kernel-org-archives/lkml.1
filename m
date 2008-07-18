Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYGRVgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYGRVgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbYGRVgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:36:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55518 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYGRVgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:36:43 -0400
Date: Fri, 18 Jul 2008 23:36:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: yhlu.kernel@gmail.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] x86: Move dma32_reserve_bootmem() after
	reserve_crashkernel()
Message-ID: <20080718213622.GA14603@elte.hu>
References: <86802c440807180922l3500082chf7dcf0a1bafc6629@mail.gmail.com> <1216400873-21862-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216400873-21862-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernhard Walle <bwalle@suse.de> wrote:

> On a x86-64 machine (nothing special I could encounter) I had the 
> problem that crashkernel reservation with the usual "64M@16M" failed. 
> While debugging that, I encountered that dma32_reserve_bootmem() 
> reserves a memory region which is in that area.
> 
> Because dma32_reserve_bootmem() does not rely on a specific offset but 
> crashkernel does, it makes sense to move the dma32_reserve_bootmem() 
> reservation down a bit. I tested that patch and it works without 
> problems. I don't see any negative effects of that move, but maybe I 
> oversaw something ...
> 
> While we strictly don't need that patch in 2.6.27 because we have the 
> automatic, dynamic offset detection, it makes sense to also include it 
> here because:
> 
>   - it's easier to get it in -stable then,
>   - many people are still used to the 'crashkernel=...@16M' syntax,
>   - not everybody may be using a reloatable kernel.

applied to tip/x86/crashdump, thanks Bernhard.

	Ingo
