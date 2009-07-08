Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZGHSF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZGHSF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZGHSFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:05:20 -0400
Received: from ey-out-1920.google.com ([74.125.78.148]:9634 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZGHSFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QJ/+crVzG6UyvbbKBOCbUgNdp+Cf0sSDOx0MI9jUfdZzByN7Wu158Q8fj3r6DHvtXs
         BmLdQU9jd02ZJ2Jiu7pz8KliU1+mgV6Dh4w3UW0x1Cc1YOQxVkikohMF2E4prS/ZAi4U
         J4ndy7k/eckrr8lqTPI0YEWKW3I2dZhgfLY64=
MIME-Version: 1.0
In-Reply-To: <1247070794.11545.123.camel@localhost.localdomain>
References: <200907081556.34682.czoccolo@gmail.com>
	 <20090708161052.GA20951@srcf.ucam.org>
	 <1247070794.11545.123.camel@localhost.localdomain>
Date: Wed, 8 Jul 2009 20:05:15 +0200
Message-ID: <4e5e476b0907081105vacafcb8s1a7e4669ef55b332@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency increase
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venki,

On Wed, Jul 8, 2009 at 6:33 PM, Pallipadi,
Venkatesh<venkatesh.pallipadi@intel.com> wrote:
> On Wed, 2009-07-08 at 09:10 -0700, Matthew Garrett wrote:
>> On Wed, Jul 08, 2009 at 03:56:33PM +0200, Corrado Zoccolo wrote:
>> > The patch introduces a new sysfs tunable cpufreq/ondemand/freq_step,
>> > as found in conservative governor, to chose the frequency increase step,
>> > expressed as percentage (default = 100 is previous behaviour).
>> >
>> > This allows fine tuning powersaving on mobile CPUs, since smaller steps will allow to:
>> > * absorb punctual load spikes
>> > * stabilize at the needed frequency, without passing for more power consuming states, and
>>
>> Is this a measured powersaving? The ondemand model is based on the
>> assumption that the idle state is disproportionately lower in power than
>> any running state, and therefore it's more sensible to run flat out for
>> short periods of time than run at half speed for longer. Is this
>> inherently flawed, or is it an artifact of differences in your processor
>> design?
>>
>
> As Matthew mentioned, ondemand governor wants to run at highest speed
> and get to idle sooner. Another aspect of ondemand governor is to have
> very low response time for freq increase on sudden increase in load.
> With freq_step, it may take long time before we can respond to sudden
> increase of load from idle to full busy.

Yes. freq_step is a tunable that allows trading latency for power saving.

>
> Even though you have default step as 100, as soon as we have this
> variable, there will be users/distros setting it in a wrong way.
>

I think having it as a tunable adds some value, since power managing
applications could use various inputs to chose the best value at run
time.
Some of them allow to specify complex policies, as switch to powersave
governor when battery charge is below a threshold.
With this change, one can gradually transition from current ondemand
to powersave, passing through intermediate states,
by feeding back the battery charge % into it, so the system is more
responsive when fully charged, and tries to save more power when it is
running low.

> So, it will be interesting to see any data you have with and without
> this change.

Ok, I'll collect some data.

>
> Alternatives to explore would be:
> - Can we identify some characteristics of this system and turn this on
> automatically instead of user tunable.
I think the user tunable has some reason to exist, to implement more
complex user policies as explained above.
We can identify, though, cases in which this should never be enabled,
like the P4s, in which the clock modulation reduces also the
memory-cache bandwidth. In those cases, the additional latency is very
noticeable, and can also be a loss in terms of power.

> - Long standing goal of combining conservative and ondemand with a
> mode_switch at the driver load, instead of run time tunables.
>
> Thanks,
> Venki
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
