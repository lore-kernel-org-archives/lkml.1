Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZBWM0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZBWM0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZBWM0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:26:09 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:20922 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbZBWM0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:26:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ubr0UlgGROPOGk+Ihe+xaApzQWVucrHe+NFauj/tiC59CevT4APw+RcLlwfJKH9Zay
         ZnfpI3odk8Ay/L1bYjyF2mtN0oOc1Xf5mzOmgCSzOPvUfZpWui1+8Aq33RiZMDtbi7h3
         grP2hVBHHERUg3wGRqqMAZ6kqtrrF6PK0lHL4=
MIME-Version: 1.0
In-Reply-To: <49A258A2.2020408@nokia.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com>
	 <200902201311.44056.david-b@pacbell.net>
	 <4d34a0a70902222141y345a7bc3g314e6de5df156f2d@mail.gmail.com>
	 <49A258A2.2020408@nokia.com>
Date: Mon, 23 Feb 2009 21:26:06 +0900
X-Google-Sender-Auth: 0e6081b63e80d396
Message-ID: <9c9fda240902230426s2003d208xebeb6630c61b3bec@mail.gmail.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when 
	resuming
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Kim Kyuwon <chammoru@gmail.com>, David Brownell <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?EUC-KR?B?seix1L/4?= <q1.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 23, 2009 at 5:04 PM, Adrian Hunter
<ext-adrian.hunter@nokia.com> wrote:
> ext Kim Kyuwon wrote:
>> Hi,
>>
>> On Sat, Feb 21, 2009 at 6:11 AM, David Brownell <david-b@pacbell.net> wrote:
>>> On Friday 20 February 2009, Kim Kyuwon wrote:
>>>> +static void omap_hsmmc_init(struct mmc_omap_host *host)
>>>> +{
>>>> +       u32 hctl, capa, value;
>>>> +
>>>> +       /* Only MMC1 supports 3.0V */
>>>> +       if (host->id == OMAP_MMC1_DEVID) {
>>>> +               hctl = SDVS30;
>>> Shouldn't it be remembering what voltage it was using,
>>> and then restore that, instead of always making MMC1
>>> restart at a 3.0V level?  That's pretty awkward to test
>>> unless you have a 1.8V-capable card in MMC1...
>>
>> You are somewhat right, thank you.
>> But remebering what voltage it was using doesn't feasible to me,
>> because the card can be changed while in 'Sleep' state. I should have
>> inserted a function that detect the right voltage after intializing. I
>> will resend the patch later.
>
> Doesn't it already do that? Can you explain more?
>
> Although I have not tested it, I very much doubt
> dual-voltage cards work.  That is because VMMC1_185V
> is zero, which has the side-effect of turning the
> regulator off (see arch/arm/mach-omap2/mmc-twl4030.c)

It's also to difficult to test in our H/W since it's configured only
support 3.0V.

How about to separate it two phases, first fix the mmc suspend/resume
works again, and then verify dual voltage if there are these hardware

How to you think?

Thank you,
Kyungmin Park
