Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYHMRSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYHMRSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYHMRSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:18:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbYHMRSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:18:15 -0400
Date: Wed, 13 Aug 2008 10:17:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
In-Reply-To: <200808131209.57534.mark.langsdorf@amd.com>
Message-ID: <alpine.LFD.1.10.0808131011050.3462@nehalem.linux-foundation.org>
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813164728.GD5720@elte.hu> <200808131209.57534.mark.langsdorf@amd.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Mark Langsdorf wrote:
> 
> I don't think it's necessary.  I can submit a delta patch later if you
> think it's really necessary.

Why not at least move it to after the local_irq_disable()?

That local_irq_disable() will do tons of writes if you have 
lockdep enabled, it calls trace_hardirqs_off() etc. Maybe they don't end 
up ever mattering, but wouldn't it make much more sense to just move the 
wbinvd down to just before the

	while (1)
		halt();

which is also likely to make sure that the compiler won't do anything at 
all because everything is dead at that point with no function calls etc 
happening.

			Linus
