Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYK1OeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYK1OeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYK1OeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 09:34:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45333 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbYK1Od7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 09:33:59 -0500
Date: Fri, 28 Nov 2008 15:33:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: aperture_64.c: clarify that too small aperture is valid reason
	for this code
Message-ID: <20081128143346.GF28138@elte.hu>
References: <20081126161527.GE1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126161527.GE1983@elf.ucw.cz>
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


* Pavel Machek <pavel@suse.cz> wrote:

> Clarify that too small aperture is valid reason for this code.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 9a32b37..026fcfb 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -1,8 +1,9 @@
>  /*
>   * Firmware replacement code.
>   *
> - * Work around broken BIOSes that don't set an aperture or only set the
> - * aperture in the AGP bridge.
> + * Work around broken BIOSes that don't set an aperture, only set the
> + * aperture in the AGP bridge, or set too small aperture.
> + *

applied to tip/x86/iommu, thanks Pavel!

That comment is indeed highly misleading - and sets the wrong mindset for 
people who start reading this file. The list you add it to are indeed the 
most common reasons for us to (re-)allocate the aperture.

Would you be interested in sending a patch for a full list of situations 
where we declare the existing aperture invalid and reallocate it? It will 
certainly help understanding the purpose and role of this file.

	Ingo
