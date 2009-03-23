Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZCWIkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZCWIkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZCWIk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:40:26 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64660 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZCWIkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:40:25 -0400
Message-ID: <49C74AEF.1060508@atmel.com>
Date: Mon, 23 Mar 2009 09:40:15 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       David Brownell <david-b@pacbell.net>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>
Subject: Re: [RFC PATCH] AT91: manage clock by functionality instead of CPUs
References: <49C37677.8090508@atmel.com> <20090322115710.GV10127@sci.fi>
In-Reply-To: <20090322115710.GV10127@sci.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ville,

Ville Syrjälä :
> On Fri, Mar 20, 2009 at 11:56:55AM +0100, Nicolas Ferre wrote:
>> --- a/arch/arm/mach-at91/clock.c
>> +++ b/arch/arm/mach-at91/clock.c
>> @@ -45,6 +45,25 @@
>>  #define clk_is_sys(x)		((x)->type & CLK_TYPE_SYSTEM)
>>  
>>  
>> +/*
>> + * Chips have some kind of clocks : group them by functionality
>> + */
>> +#define cpu_has_utmi()		(  cpu_is_at91cap9() \
>> +				|| cpu_is_at91sam9rl())
>> +
>> +#define cpu_has_800M_plla()	(cpu_is_at91sam9g20())
>> +
>> +#define cpu_has_pllb()		(!(cpu_is_at91sam9rl()))
> 
> Useless parentheses.

Ok.

>> +
>> +#define cpu_has_upll()		(0)
> 
> Is this for some future chip?

Definitely, yes !

>> +
>> +/* USB host HS & FS */
>> +#define cpu_has_uhp()		(!cpu_is_at91sam9rl())
>> +
>> +/* USB device FS only */
>> +#define cpu_has_udpfs()		(!(cpu_is_at91sam9rl()))
> 
> Useless parentheses.

Ok.


>> @@ -175,7 +194,12 @@ static struct clk __init *at91_css_to_cl
>>  		case AT91_PMC_CSS_PLLA:
>>  			return &plla;
>>  		case AT91_PMC_CSS_PLLB:
>> -			return &pllb;
>> +			if (cpu_has_upll())
>> +				/* CSS_PLLB == CSS_UPLL */
>> +				return &utmi_clk;
>> +			else
>> +				if (cpu_has_pllb())
>> +					return &pllb;
> 
> Put "else if" on one line?

Ok.


Thanks for your review, cheers,
-- 
Nicolas Ferre

