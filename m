Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZJZUT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZJZUT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZJZUT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:19:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbZJZUT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:19:26 -0400
Date: Mon, 26 Oct 2009 21:19:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, hpa@zytor.com
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent allocations
Message-ID: <20091026201917.GE24682@elte.hu>
References: <4AE06644020000780001B4AD@vpn.id2.novell.com> <20091023114825.GH5886@elte.hu> <4AE5CA8C020000780001BD09@vpn.id2.novell.com> <20091026152246.GB3749@elte.hu> <4AE5D238020000780001BD46@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE5D238020000780001BD46@vpn.id2.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 26.10.09 16:22 >>>
> >* Jan Beulich <JBeulich@novell.com> wrote:
> >> And any attempt to eliminate the conditional another way would just 
> >> introduce a very similar conditional elsewhere; with this having a 
> >> single user (and foreseeably not ever a second one) I would think this 
> >> would just make the code less readable.
> >
> >There's 3 other current uses of DMA_BIT_MASK(24) in arch/x86 - couldnt 
> >those use ISA_DMA_BIT_MASK too?
> 
> Oh, so you didn't mean me to eliminate the conditional in pci-dma.c, 
> but just to replace the DMA_BIT_MASK(24) here an elsewhere. Sure, I'm 
> fine with adding this to the patch.

Well, can ISA_BIT_MASK fall back to DMA_BIT_MASK(32) on !CONFIG_ISA? If 
we have ISA support disabled we might as well pretend the whole world is 
PCI, right?

That way we'd get rid of that #ifdef in the .c code too.

	Ingo
