Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab0BKUfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:35:01 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:42118 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab0BKUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:34:59 -0500
Message-ID: <4B746A02.9060306@billgatliff.com>
Date: Thu, 11 Feb 2010 14:35:14 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution
 timer and a GPIO pin
References: <cover.1265094517.git.bgat@billgatliff.com> <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com> <20100211200702.GB1487@ucw.cz>
In-Reply-To: <20100211200702.GB1487@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> +static void
>> +gpio_pwm_work (struct work_struct *work)
>> +{
>> +	struct gpio_pwm *gp = container_of(work, struct gpio_pwm, work);
>> +
>> +	if (gp->active)
>> +		gpio_direction_output(gp->gpio, gp->polarity ? 1 : 0);
>> +	else
>> +		gpio_direction_output(gp->gpio, gp->polarity ? 0 : 1);
>> +}
>>     
>
> ...polarity ^ active ?
>   

... except that if polarity and/or active are >1, I don't send the
values 1 or 0 to gpio_direction_output.  I don't know if the API is
specifically intended to accept nonzero values that are greater than 1.


b.g.

-- 
Bill Gatliff
Embedded systems training and consulting
http://billgatliff.com
bgat@billgatliff.com

