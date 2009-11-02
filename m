Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZKBRMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZKBRMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZKBRMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:12:51 -0500
Received: from mail.atmel.fr ([81.80.104.162]:37265 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325AbZKBRMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:12:50 -0500
Message-ID: <4AEF12B7.3040704@atmel.com>
Date: Mon, 02 Nov 2009 18:11:19 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>, Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.infradead.org
CC: =?ISO-8859-1?Q?=22=5C=22Thiago_A=2E=5C=22_Corr=EAa=22?= 
	<thiago.correa@gmail.com>,
       kernel@avr32linux.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3/3 v2] at91/atmel-mci: inclusion of sd/mmc driver in
  at91sam9g45 chip and board
References: <acfa557032a93e2d3186981b16f7048a5a31028a.1256314995.git.nicolas.ferre@atmel.com>	 <20090930155557.7dae503b@hskinnemoen-d830>	 <a3b1332815576dc4d496937b8a5ab69d36818d00.1256314995.git.nicolas.ferre@atmel.com>	 <cd73a99e0910271243x744c956bl598fef9fd4144840@mail.gmail.com>	 <20091028083548.38f1d80c@hskinnemoen-d830>	 <d6cda7730910271753o54acfa04t1225de460083325f@mail.gmail.com>	 <cd73a99e0910281253x1bb72b74p47cb5110efb0871f@mail.gmail.com> <1256763057.4362.36.camel@ben-desktop>
In-Reply-To: <1256763057.4362.36.camel@ben-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette :
> On Wed, 2009-10-28 at 21:53 +0200, Andrew Victor wrote:
>> hi,
>>
>>> Then I think it would be best to use GPIO_PIN_NONE. Makes it clear
>>> what is expected and avoids confusion on what should be the proper
>>> value.
>>> I hope I'm not saying non-sense, but even if I am, I guess you can see
>>> that I'm advocating against the magic numbers :)
>> What magic numbers ?
> 
> I think Thiago was referring to the "-1" in the original patch as the
> magic number.
> 
> Leaving the field blank to be initialised to 0 is certainly the
> cleanest, I agree, but it doesn't actually /work/.  On many archs 0 is a
> valid gpio number; the gpio_is_valid check used throughout the kernel
> (including atmel-mci.c) looks like
> 
> static inline int gpio_is_valid(int number)
> {
> 	/* only some non-negative numbers are valid */
> 	return ((unsigned)number) < ARCH_NR_GPIOS;
> }

I understand that the better way to solve this issue is to:
- keep the AT91 way of specifying not connected pins (= 0)
- code the gpio_is_valid() function for at91 that tests this way of
handling not connected gpio

I see that in arch/arm/mach-at91/include/mach/gpio.h
we include the asm-generic/gpio.h file... must I implement the full set
of gpiolib ?

Best regards,
-- 
Nicolas Ferre

