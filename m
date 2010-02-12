Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0BLNxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 08:53:39 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:60034 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751429Ab0BLNxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 08:53:37 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution timer and a GPIO pin
Date: Fri, 12 Feb 2010 08:53:30 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902153515@mi8nycmail19.Mi8.com>
In-Reply-To: <4B746A02.9060306@billgatliff.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution timer and a GPIO pin
Thread-Index: AcqrWbfwMUEJZ9AaR224eAagyG/E0AAj5iUg
References: <cover.1265094517.git.bgat@billgatliff.com> <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com> <20100211200702.GB1487@ucw.cz> <4B746A02.9060306@billgatliff.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Bill Gatliff" <bgat@billgatliff.com>, "Pavel Machek" <pavel@ucw.cz>
Cc: <linux-embedded@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Feb 2010 13:53:35.0559 (UTC) FILETIME=[C5602570:01CAABEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thursday, February 11, 2010 1:35 PM, Bill Gatliff wrote:
> Pavel Machek wrote:
>>> +static void
>>> +gpio_pwm_work (struct work_struct *work)
>>> +{
>>> +	struct gpio_pwm *gp = container_of(work, struct gpio_pwm, work);
>>> +
>>> +	if (gp->active)
>>> +		gpio_direction_output(gp->gpio, gp->polarity ? 1 : 0);
>>> +	else
>>> +		gpio_direction_output(gp->gpio, gp->polarity ? 0 : 1);
>>> +}
>>>     
>>
>> ...polarity ^ active ?
>>   
>
> ... except that if polarity and/or active are >1, I don't send the
> values 1 or 0 to gpio_direction_output.  I don't know if the API is
> specifically intended to accept nonzero values that are greater than 1.

FWIW, the gpiolib API will accept any non-zero value to "set" a gpio pin
and a zero value to "clear" the pin.

For that matter, some of the gpiolib drivers end up returning the bit
position mask for a given gpio pin and not 1 or 0.  For instance if the
gpio pin in question is bit 6 in an 8-bit register and it is set, a
__gpio_get_value will end up returning 0x40 and not '1'.

Regards,
Hartley
