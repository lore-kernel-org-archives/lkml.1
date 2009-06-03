Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbZFCIMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbZFCIMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZFCIMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:12:36 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:53527 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZFCIMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:12:34 -0400
References: <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090512060231.GB26286@liondog.tnic> <cone.1242669880.118150.4276.1000@deskpiie> <20090524192219.GA30285@liondog.tnic> <cone.1243865541.882421.4368.1000@deskpiie> <20090603073552.GA2671@liondog.tnic>
Message-ID: <cone.1244016635.374757.16292.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Wed, 03 Jun 2009 10:10:35 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Borislav Petkov writes:

> Hi,
> 
> On Mon, Jun 01, 2009 at 04:12:21PM +0200, Peter Feuerer wrote:
>>> Ok, minor nitpicks below but it starting to shape up quite ok. You could
>>> send it for inclusion upstream.
>>
>> How exactly do I send the patch for inclusion?
> 
> just rediff it against latest git and send an email to Len Brown (i
> assume, from looking at git log drivers/thermal/ output) requesting for
> driver inclusion.
> 
> Len?
> 
> If you hurry and do it this week it might be possible to get it in .31
> because the merge window opens around the coming weekend.

Ok, I'll try to directly address len with subject "Request driver inclusion 
acer aspire one fan control" and send a diff against latest git, right? 
(CC'ing lkml of course). Just wondering if it'll work, as Len has always 
been included via CC into our discussions and has never said anything :-(

>>>> +			acerhdf_notice("temp %d\n", temp);
>>>> +		return temp;
>>>> +	}
>>>> +	return ACERHDF_ERROR;
>>>> +}
>>>> +
>>>> +
>>>> +		if (verbose)
>>>> +			acerhdf_error("read state: %d expected state: %d\n",
>>>> +					old_state, fanstate);
>>>> +
>>>> +		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>>>> +		disable_kernelmode = 1;
>>>> +	}
>>>> +
>>>> +	if (state == 0) {
>>>> +		/* turn fan off only if below fanoff temperature */
>>>> +		if ((old_state == ACERHDF_FAN_AUTO) &&
>>>> +				(acerhdf_get_temp() < fanoff))
>>>
>>> it might be cool to tell the user why you're not turning off the fan.
>>>
>>> 		if (verbose)
>>> 			acerhdf_notice("Not turning off fan due to current temp "
>>> 				       "exceeding fanoff value\n");
>>>
>>
>> Hm.. I think it should be clear that the fan is turned off, as soon as 
>> the temperature is below the fanoff temperature. In my opinion printing 
>> this message would be a case for a "verbose==2" verbose mode :)
> 
> My reasoning was that because this is called from sysfs and the user
> sees nothing happening even if he'd turned off the fan by calling
> .set_cur_state that it might be useful to tell him why.

But the user isn't allowed to change the fan state from userspace anymore. 
If you try to change the fan state from userspace you'll get the "changing 
fan state is not allowed" message.

best regards,
--peter
