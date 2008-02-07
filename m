Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbYBGLzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbYBGLzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 06:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYBGLzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 06:55:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbYBGLzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 06:55:00 -0500
Date: Thu, 7 Feb 2008 12:54:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix page table size
Message-ID: <20080207115442.GB387@elte.hu>
References: <200802061246.43413.yinghai.lu@sun.com> <200802061501.26533.yinghai.lu@sun.com> <20080206231226.GA6417@elte.hu> <200802062022.44069.yinghai.lu@sun.com> <p73wsph2pry.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73wsph2pry.fsf@bingen.suse.de>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
> >
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index eb376b5..31f0e82 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -370,7 +370,7 @@ static void __init find_early_table_space(unsigned long end)
> >  
> >  	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
> >  	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
> > -	if (direct_gbpages) {
> > +	if (!direct_gbpages) {
> 
> What tree did you use? The patch I submitted had 
> 
>      if (direct_gbpages == GBP_ON) { 

yes, the bug was introduced in your original submission of gbpages.

	Ingo
