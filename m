Return-Path: <linux-kernel-owner+w=401wt.eu-S1751042AbXDLPAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbXDLPAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXDLPAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:00:11 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:21308 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXDLPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AbBgGoXVEnodOZDLGxrFFhZ3z0zzCI+xM6aH0rDRXiz7JFLbT+J05Vm0LyS2IRBlwznDuVREl6GCK6R9uVF9j20IuBzde8cSXQJur+X94XbzAffjA3yOthtI2qqM36sk7auEs4huGFbUSw5oM85Q/ylOwOcy/0ScNdPDB+qC4V4=
Message-ID: <41840b750704120800l6ab2b0f8qeda6931d7c7e9bc6@mail.gmail.com>
Date: Thu, 12 Apr 2007 11:00:07 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Anton Vorontsov" <cbou@mail.ru>
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
In-Reply-To: <20070411232503.GC20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070411232503.GC20095@zarina>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

A few comments on the ever-contentious choice of battery attributes:

On 4/11/07, Anton Vorontsov <cbou@mail.ru> wrote:
> + * All voltages, currents, capacities and temperatures in mV, mA, mAh and
> + * tenths of a degree unless otherwise stated. It's driver's job to convert
> + * its raw values to which this class operates. If for some reason driver
> + * can't afford this requirement, then it have to create its own attributes,
> + * plus additional "XYZ_units" for each of them.
> + */

Many (most, I believe) laptop batteries report capacity in mWh
(energy), not mAh (charge). You can't convert between the two without
a detailed, up-to-date physical model of the battery. This is too
common to relegate to a non-standardized "XYZ_units" extension.


> +BATTERY_INT_ATTR(min_voltage);
> +BATTERY_INT_ATTR(min_current);
> +BATTERY_INT_ATTR(min_capacity);
> +BATTERY_INT_ATTR(max_voltage);
> +BATTERY_INT_ATTR(max_current);
> +BATTERY_INT_ATTR(max_capacity);
> +BATTERY_INT_ATTR(temp);
> +BATTERY_INT_ATTR(voltage);
> +BATTERY_INT_ATTR(current);
> +BATTERY_INT_ATTR(capacity);

I suggest adding "remaining operating time" and "remaining charging
time". You can try deducing these from the above attributes, but in
practice this gives very inaccurate predictions. On laptops (e.g.,
ThinkPad) the BIOS or EC often provides much better estimates, using a
more accurate physical model.

I also see you omitted a host of other common attributes, like design
capacity, cycle count, model string, and temperatures. There was an
extensive LKML discussion of the choice and naming of attributes, in
the context of David Woodhouse's patch; there are futher observations
there. Also, here's the list of attributes in my tp_smapi ThinkPad
driver: http://thinkwiki.org/wiki/tp_smapi#Battery_charge_control_features

Does "max capaxity" correspond to what's usually denoted "last full capacity".

I understand you allow adding custom attributes, but they're of
limited use if generic userspace tools don't know their name and
semantics. It's important to standardize all reasonably common
attributes.

  Shem
