Return-Path: <linux-kernel-owner+w=401wt.eu-S934877AbZLPJkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877AbZLPJkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 04:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934866AbZLPJkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 04:40:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:11250 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934863AbZLPJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 04:40:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bvq0jp+OLpt9BzV6/X320S+mEjnkLoRCIVQv3WrB+OJKEsd3ziA7/X3ZMIKbUsYkpN
         xcFyFiqMWnKzhdvPTtS/4nSngpHLba6Rb9t2cbXbbbIXvyjhsohyxqJkn/bptodudDnY
         mDl9eTiwHQJ3jjJuPEl5ozYZuHy43Ww6z/rwI=
Message-ID: <4B28AAFC.5010108@warmcat.com>
Date: Wed, 16 Dec 2009 09:40:12 +0000
From: Andy Green <andy@warmcat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stanislav Brabec <utx@penguin.cz>
CC: Aras Vaichas <arasv@magellan-technology.com>,
       Bill Gatliff <bgat@billgatliff.com>, thommycheck@gmail.com,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-embedded@vger.kernel.org, lenz@cs.wisc.edu, dbaryshkov@gmail.com,
       Brian Swetland <swetland@google.com>, arminlitzel@web.de,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de, cbou@mail.ru,
       rpurdie@rpsys.net, omegamoon@gmail.com, Pavel Machek <pavel@ucw.cz>,
       Cyril Hrubis <metan@ucw.cz>, eric.y.miao@gmail.com, dwmw2@infradead.org,
       zaurus-devel@www.linuxtogo.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [POWER] battery calibration parameters from sysfs
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>	<A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>	<20091207114825.GA26965@rakim.wolfsonmicro.main>	<A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>	<20091207165628.GA24981@rakim.wolfsonmicro.main>	<20091213132413.GB1437@ucw.cz>	<20091214121247.GB22388@rakim.wolfsonmicro.main>	<20091214212257.GA9213@elf.ucw.cz>	<ed62800912141543v2ab7ef63v4b6b2c33018b3296@mail.gmail.com>	<4B26FC52.6060307@billgatliff.com>	<ed62800912151458p6bc1e551g54960af40c54facd@mail.gmail.com> <1260919938.10441.18.camel@utx.utx.cz>
In-Reply-To: <1260919938.10441.18.camel@utx.utx.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/09 23:32, Somebody in the thread at some point said:

Hi -

>> Yes, but in that case you might as well just purchase a coulomb
>> counter with a built-in accumulator and an I2C/SPI/microwire interface
>> save yourself some PCB space and cost (maybe)
>
> Well, Pavel attempts to implement a "poor man's Coulomb counter" or at
> least "poor man's Ampere meter" for devices that are not equipped with
> any of it.

I think the "poor man's Coulomb counter" is a loser, the errors will 
overwhelm you too rapidly.  The estimated rate of discharge could work, 
based on what clocks, regulators and so on are running, but I am not 
sure how useful that number is really given you can't realistically 
integrate it due to the big error it is bound to have.

I didn't see it mentioned yet but the biggest problem I saw with battery 
state monitoring by voltage alone is what happens during charging: the 
charger is artificially raising the voltage by an amount depending on 
current limit in the charger and battery capacity level.  That's what 
you see when you go and look at battery voltage during charging.

Otherwise for L-ion batteries, looking at the voltage level alone, 
filtered to remove GSM transmit slots etc, is really quite workable for 
estimating charge status.

-Andy
