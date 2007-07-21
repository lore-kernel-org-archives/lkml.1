Return-Path: <linux-kernel-owner+w=401wt.eu-S935062AbXGUHcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935062AbXGUHcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 03:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbXGUHcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 03:32:39 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:61023 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbXGUHci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 03:32:38 -0400
Date: Sat, 21 Jul 2007 10:32:31 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <gcosta@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use wbinvd() macro instead of raw inline assembly in .c files
Message-ID: <20070721073231.GG4152@rhun.haifa.ibm.com>
References: <1184885740.16311.19.camel@t60> <200707201343.59962.ak@suse.de> <46A0EF4D.6030308@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A0EF4D.6030308@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:22:21AM -0700, H. Peter Anvin wrote:

> Andi Kleen wrote:
> > On Friday 20 July 2007 00:55:40 Glauber de Oliveira Costa wrote:
> >> This patch uses the already-existant wbinvd() macro to replace
> >> raw assembly to perform this very same task in some .c files
> >>     
> >> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> >>
> >> diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
> >> index f61fb8e..afbb951 100644
> >> --- a/arch/x86_64/kernel/tce.c
> >> +++ b/arch/x86_64/kernel/tce.c
> >> @@ -42,7 +42,7 @@ static inline void flush_tce(void* tceaddr)
> >>  	if (cpu_has_clflush)
> >>  		asm volatile("clflush (%0)" :: "r" (tceaddr));
> >>  	else
> >> -		asm volatile("wbinvd":::"memory");
> >> +		wbinvd();
> > 
> > I guess it can be just removed there. I don' think there are any
> > calgary machines without clflush
> > 
> That seems like an unsafe thing to do (unless we err out somewhere);
> lest there is, say, a microcode update disabling clflush due to an
> erratum.

I agree.

Cheers,
Muli
