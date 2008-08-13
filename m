Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYHMRZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYHMRZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYHMRY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:24:56 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:36496 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYHMRYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:24:55 -0400
X-BigFish: VPS-40(zz1432R9370P98dR1805M936fQzz10d3izzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5JV14-01-IOJ-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: invalidate caches before going into suspend
Date: Wed, 13 Aug 2008 12:30:07 -0500
User-Agent: KMail/1.9.9
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <200808131141.18003.mark.langsdorf@amd.com> <200808131209.57534.mark.langsdorf@amd.com> <alpine.LFD.1.10.0808131011050.3462@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808131011050.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200808131230.07581.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 13 Aug 2008 17:24:48.0455 (UTC) FILETIME=[7CA39D70:01C8FD69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008, Linus Torvalds wrote:
> 
> On Wed, 13 Aug 2008, Mark Langsdorf wrote:
> > 
> > I don't think it's necessary.  I can submit a delta patch later if you
> > think it's really necessary.
> 
> Why not at least move it to after the local_irq_disable()?
> 
> That local_irq_disable() will do tons of writes if you have 
> lockdep enabled, it calls trace_hardirqs_off() etc. Maybe they don't end 
> up ever mattering, but wouldn't it make much more sense to just move the 
> wbinvd down to just before the
> 
> 	while (1)
> 		halt();
> 
> which is also likely to make sure that the compiler won't do anything at 
> all because everything is dead at that point with no function calls etc 
> happening.

I don't think we realized that local_irq_disable() did all that and
so we only tested the submitted patch.  I've resubmitted the unified
patch after applying your suggestion.  Thanks.

-Mark Langsdorf
Operating System Research Center
AMD

