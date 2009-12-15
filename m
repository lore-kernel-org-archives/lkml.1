Return-Path: <linux-kernel-owner+w=401wt.eu-S933461AbZLOUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbZLOUXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932802AbZLOUXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:23:48 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:53304 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933083AbZLOUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:23:47 -0500
Message-ID: <4B27F075.5000908@bluewatersys.com>
Date: Wed, 16 Dec 2009 09:24:21 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
References: <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com> <20091214064545.GK5114@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE19090200E9E6@mi8nycmail19.Mi8.com> <20091215194725.GH24406@elf.ucw.cz>
In-Reply-To: <20091215194725.GH24406@elf.ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> +int gpio_to_irq(unsigned gpio)
>>> +{
>>> +	return -EINVAL;
>>> +}
>> This should probably just be an inline function in
>> arch/arm/mach-msm/include/mach/gpio.h
> 
> Well, it is not performance critical in any way and it is likely to
> change in future. I'd leave it here.

If this function eventually does do something interesting, it would be
useful to have it as a macro in arch/arm/mach-msm/include/mach/gpio.h
since it can be used for static/define declarations, ie:

#define SOME_GPIO_IRQ gpio_to_irq(SOME_GPIO)

>>> +extern int gpio_to_irq(unsigned gpio);
>> This should probably be an inline as mentioned above.
>>
>> For completeness you should probably also add:
>>
>> static inline int irq_to_gpio(unsigned irq)
>> {
>> 	return -EINVAL;
>> }
> 
> I'd say that would be overdoing it.

You should implement this if you have gpio_to_irq because it is part of
the API, see include/linux/gpio.h

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
