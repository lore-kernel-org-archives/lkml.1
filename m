Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZJZPXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZJZPXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZJZPXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:23:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbZJZPXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:23:03 -0400
Date: Mon, 26 Oct 2009 16:22:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, hpa@zytor.com
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent allocations
Message-ID: <20091026152246.GB3749@elte.hu>
References: <4AE06644020000780001B4AD@vpn.id2.novell.com> <20091023114825.GH5886@elte.hu> <4AE5CA8C020000780001BD09@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE5CA8C020000780001BD09@vpn.id2.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 23.10.09 13:48 >>>
> >makes sense (although there were a few odd ends in various ISA sound 
> >driver details so this should go on the .33 not .32), but please 
> >introduce a cleaner construct, like a new DMA_ISA_BIT_MASK() or so.
> 
> Hmm, I could see DMA_ISA_BIT_MASK only replace DMA_BIT_MASK(24) (but 
> specifically not being conditional upon CONFIG_ISA) without becoming 
> confusing. Consequently this would eliminate the conditional in the .c 
> file. [...]
>
> Or did you have something else in mind that I just don't realize?

DMA_ISA_BIT_MASK was what i had in mind.

> And any attempt to eliminate the conditional another way would just 
> introduce a very similar conditional elsewhere; with this having a 
> single user (and foreseeably not ever a second one) I would think this 
> would just make the code less readable.

There's 3 other current uses of DMA_BIT_MASK(24) in arch/x86 - couldnt 
those use ISA_DMA_BIT_MASK too?

	Ingo
