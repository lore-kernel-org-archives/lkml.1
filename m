Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0BJNyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:54:54 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:61606 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0BJNyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:54:52 -0500
Message-ID: <4B72BAB8.4090008@billgatliff.com>
Date: Wed, 10 Feb 2010 07:55:04 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 1/7] API to consolidate PWM devices behind a common
 user and kernel interface
References: <cover.1265748263.git.bgat@billgatliff.com> <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE190902153279@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902153279@mi8nycmail19.Mi8.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
>> +int pwm_set_polarity(struct pwm_channel *p,
>> +		     int active_high)
>> +{
>> +	struct pwm_channel_config c = {
>> +		.config_mask = PWM_CONFIG_POLARITY,
>> +		.polarity = active_high,
>> +	};
>> +	return pwm_config(p, &c);
>> +}
>> +EXPORT_SYMBOL(pwm_set_polarity);
>>     
>
> Has the 'polarity' logic been verified?
>
> pwm_set_polarity takes an active high flag that is passed to pwm_config.
> A write to the sysfs 'polarity' file passes the value directly to pwm_config.
> A read from the sysfs 'polarity' file returns struct pwm_channel ->active_low.
>
> Seems like a mis-match in logic.
>   

It was.  And on top of that, none of the drivers were reflecting their
polarity in their pwm_channel structures.

I renamed the channel structure variable to active_high for consistency,
and updated each of the drivers to set that value consistent with their
actual polarities.

Very good catch.



b.g.

-- 
Bill Gatliff
Embedded systems training and consulting
http://billgatliff.com
bgat@billgatliff.com

