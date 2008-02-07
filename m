Return-Path: <linux-kernel-owner+w=401wt.eu-S1759768AbYBGINH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768AbYBGINH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYBGIMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:12:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbYBGIMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:12:53 -0500
Date: Thu, 7 Feb 2008 09:12:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: clean up find_e820_area
Message-ID: <20080207081239.GC28631@elte.hu>
References: <200802061246.43413.yinghai.lu@sun.com> <20080206231226.GA6417@elte.hu> <200802062022.44069.yinghai.lu@sun.com> <200802062023.30427.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802062023.30427.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: clean up find_e820_area
> 
> change size to unsigned long, becase caller and user all used unsigned 
> long. also make bad_addr take align.

thanks, applied.

[ tiny nitpicking detail:

 > -static inline int bad_addr(unsigned long *addrp, unsigned long size)
 > +static inline int bad_addr(unsigned long *addrp, unsigned long size, unsigned long align)

 please run scripts/checkpatch.pl over your patches, that would have 
 caught the above overlong line. ]

> @@ -105,7 +105,7 @@ again:
>  	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
>  		struct early_res *r = &early_res[i];
>  		if (last >= r->start && addr < r->end) {
> -			*addrp = addr = r->end;
> +			*addrp = addr = round_up(r->end, align);

nice! This makes the reservation intent and effect much clearer.

	Ingo
