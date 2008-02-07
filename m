Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYBGR1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYBGR1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYBGR10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:27:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:38264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYBGR1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:27:25 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: fix page table size
Date: Thu, 7 Feb 2008 18:28:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200802061246.43413.yinghai.lu@sun.com> <p73wsph2pry.fsf@bingen.suse.de> <20080207115442.GB387@elte.hu>
In-Reply-To: <20080207115442.GB387@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071828.26468.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 12:54:42 Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> > Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
> > > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > > index eb376b5..31f0e82 100644
> > > --- a/arch/x86/mm/init_64.c
> > > +++ b/arch/x86/mm/init_64.c
> > > @@ -370,7 +370,7 @@ static void __init find_early_table_space(unsigned
> > > long end)
> > >
> > >  	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
> > >  	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
> > > -	if (direct_gbpages) {
> > > +	if (!direct_gbpages) {
> >
> > What tree did you use? The patch I submitted had
> >
> >      if (direct_gbpages == GBP_ON) {
>
> yes, the bug was introduced in your original submission of gbpages

I see yes. The original was ok I think, but it must have been a typo when
I switched the boolean to a enum on Thomas request and for some
reason the new breakage didn't show up on my testing.

I wonder why you didn't keep the enum even though Thomas
insisted on it. Since you removed it again the safest would have been
to just keep it correct as it originally was. And it was rather pointless
to force me to do changes when you then afterwards half way rewrite the code 
anyways. To be honest that habit makes it rather unpleasant to submit
patch to you recently. At least you could have indicated that in advance
and safe everybody trouble.

-Andi
