Return-Path: <linux-kernel-owner+w=401wt.eu-S1423320AbXDYIyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423320AbXDYIyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423323AbXDYIyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:54:16 -0400
Received: from penedo.hst.terra.com.br ([200.176.10.213]:38354 "EHLO
	penedo.hst.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423320AbXDYIyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:54:15 -0400
X-Terra-Karma: -2%
X-Terra-Hash: 522416032c22b31501f7865879913021
Message-ID: <462DF774.50404@centralinf.com.br>
Date: Tue, 24 Apr 2007 09:26:28 -0300
From: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.21-rc7: HPET enabled freeze my machine at boot
References: <4627D7CF.3070002@centralinf.com.br>	 <1f1b08da0704201453i1b2388der1dfe778633fbf6ea@mail.gmail.com>	 <462A9926.2030303@centralinf.com.br>  <1177367429.12242.7.camel@localhost> <1177368785.12242.9.camel@localhost>
In-Reply-To: <1177368785.12242.9.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John,

Removing the three lines doesn't help too. It just boot ok with 
clocksource=acpi_pm.

Guilherme M. Schroeder
Network Administrator
Central de Vendas Informatica LTDA
Tel.: (11) 3665-2000 Ramal: 2008
http://www.centralinf.com.br


john stultz wrote:
> On Mon, 2007-04-23 at 15:30 -0700, john stultz wrote:
>> On Sat, 2007-04-21 at 20:07 -0300, Guilherme M. Schroeder wrote:
>>> john stultz wrote:
>>>> On 4/19/07, guilherme <guilherme@centralinf.com.br> wrote:
>>>>> Hi,
>>>>>
>>>>> If i enable "High Resolution Timer Support", my machine stops here at 
>>>>> boot:
>>>>>
>>>>> Clocksource tsc unstable (delta = -297340790165 ns)
>>>>> Time: hpet clocksource has been installed.
>>>>>
>>>>> If i disable HPET, it boots fine.
>>>> Hmmm.. What happens if you boot w/ clocksource=acpi_pm ?
>>>>
>>>>
>>> Boot ok with clocksource=acpi_pm and HPET enabled.
>>> Any clue?
>>
>> I'm suspecting that your HPET counter is being stopped for some reason,
>> although why I have no idea.
>>
>> Just to get a clear picture, does this happen w/ "Tickless System
>> (Dynamic ticks)" disabled in the menuconfig?
>>
>> Thomas, might we be actually stopping the HPET counter instead of
>> disabling the HPET interrupt w/ dynticks?
> 
> 
> Just a shot in the dark, but does this patch affect the behavior?
> 
> thanks
> -john
> 
> diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
> index 17d7345..14e76a5 100644
> --- a/arch/i386/kernel/hpet.c
> +++ b/arch/i386/kernel/hpet.c
> @@ -183,9 +183,6 @@ static void hpet_set_mode(enum clock_event_mode mode,
>  
>  	case CLOCK_EVT_MODE_UNUSED:
>  	case CLOCK_EVT_MODE_SHUTDOWN:
> -		cfg = hpet_readl(HPET_T0_CFG);
> -		cfg &= ~HPET_TN_ENABLE;
> -		hpet_writel(cfg, HPET_T0_CFG);
>  		break;
>  	}
>  }
> 
> 
> 
> 
