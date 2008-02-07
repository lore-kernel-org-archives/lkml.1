Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYBGHXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYBGHXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYBGHXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:23:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:36010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbYBGHXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:23:47 -0500
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix page table size
From: Andi Kleen <andi@firstfloor.org>
References: <200802061246.43413.yinghai.lu@sun.com>
	<200802061501.26533.yinghai.lu@sun.com>
	<20080206231226.GA6417@elte.hu>
	<200802062022.44069.yinghai.lu@sun.com>
Date: Thu, 07 Feb 2008 08:23:45 +0100
In-Reply-To: <200802062022.44069.yinghai.lu@sun.com> (Yinghai Lu's message of "Wed\, 06 Feb 2008 20\:22\:43 -0800")
Message-ID: <p73wsph2pry.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index eb376b5..31f0e82 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -370,7 +370,7 @@ static void __init find_early_table_space(unsigned long end)
>  
>  	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
>  	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
> -	if (direct_gbpages) {
> +	if (!direct_gbpages) {


What tree did you use? The patch I submitted had 

     if (direct_gbpages == GBP_ON) { 

here. And the actual direct gbpages patch does not even have to made
it to Linus' tree yet, just all the other gbpages patches

But yes if it really was if (direct_gbpages) { here then your change
is correct of course.

-Andi
