Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZBWHuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZBWHuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZBWHuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:50:44 -0500
Received: from smtp.nokia.com ([192.100.122.230]:22967 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZBWHuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:50:44 -0500
Message-ID: <49A258A2.2020408@nokia.com>
Date: Mon, 23 Feb 2009 10:04:50 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kim Kyuwon <chammoru@gmail.com>
CC: David Brownell <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?EUC-KR?B?seix1L/4?= <q1.kim@samsung.com>,
       =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when
 	resuming
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com>	 <200902201311.44056.david-b@pacbell.net> <4d34a0a70902222141y345a7bc3g314e6de5df156f2d@mail.gmail.com>
In-Reply-To: <4d34a0a70902222141y345a7bc3g314e6de5df156f2d@mail.gmail.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2009 07:50:18.0535 (UTC) FILETIME=[5F1ABB70:01C9958B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Kim Kyuwon wrote:
> Hi,
> 
> On Sat, Feb 21, 2009 at 6:11 AM, David Brownell <david-b@pacbell.net> wrote:
>> On Friday 20 February 2009, Kim Kyuwon wrote:
>>> +static void omap_hsmmc_init(struct mmc_omap_host *host)
>>> +{
>>> +       u32 hctl, capa, value;
>>> +
>>> +       /* Only MMC1 supports 3.0V */
>>> +       if (host->id == OMAP_MMC1_DEVID) {
>>> +               hctl = SDVS30;
>> Shouldn't it be remembering what voltage it was using,
>> and then restore that, instead of always making MMC1
>> restart at a 3.0V level?  That's pretty awkward to test
>> unless you have a 1.8V-capable card in MMC1...
> 
> You are somewhat right, thank you.
> But remebering what voltage it was using doesn't feasible to me,
> because the card can be changed while in 'Sleep' state. I should have
> inserted a function that detect the right voltage after intializing. I
> will resend the patch later.

Doesn't it already do that? Can you explain more?  

Although I have not tested it, I very much doubt
dual-voltage cards work.  That is because VMMC1_185V
is zero, which has the side-effect of turning the
regulator off (see arch/arm/mach-omap2/mmc-twl4030.c)
