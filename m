Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYIWR3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYIWR3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYIWR3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:29:45 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3986 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYIWR3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:29:44 -0400
Date: Tue, 23 Sep 2008 19:27:19 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: petkovbb@gmail.com, Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Message-ID: <20080923172719.GA9370@localhost>
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923161434.GA4444@localhost> <48D92313.3060605@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D92313.3060605@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 09:10:43PM +0400, Sergei Shtylyov wrote:
> Mark de Wever wrote:
>
>>>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>>>> index 1bce84b..c41f5b1 100644
>>>> --- a/drivers/ide/ide-tape.c
>>>> +++ b/drivers/ide/ide-tape.c
>>>> @@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>>>> {
>>>> 	idetape_tape_t *tape = drive->driver_data;
>>>> 	struct ide_atapi_pc pc;
>>>> -	char fw_rev[6], vendor_id[10], product_id[18];
>>>> +	char fw_rev[6] = {'\0'}, vendor_id[10] = {'\0'}, product_id[18] = {'\0'};
>
>>>  Do you realize how much *absolutely unnecessary* code will this bring
>>> in?
>
>> I did not, I just had a look at the code GCC produced. I did expect much
>> smaller code, but maybe that's only generated with -Os.
>
>    My imagination sufficed to foresee how much code a compiler would have 
> to produce to completely initialize the arrays of the *auto* memory class 
> -- even regardless of optimization. And all that mostly to no purpose.

I expected a rep stos based code, which isn't much code. But the code
was created without a rep, instead it used several stos opcodes. I agree
with the mostly no purpose part, since the memcpy later overwrites most
of the array.

>>> This is certainly worse than your initial patch (if it was correct).
>
>> My initial patch did work, 
>
>    If ide_fixstring() wouldn't have to do any space compression, it would 
> work. If it would have to compress spaces, 2 garbage characters would be  
> copied by it and then printed.

I didn't know that, I guess I got lucky ;-)

>> but that doesn't matter much, since Boris
>> posted another patch based on your suggestions. I like that patch better
>> as my initial patch. I'm testing it now and I expect it to work.
>
>    Me too. :-)

It worked, thanks for your suggestion :-)

Regards,
Mark de Wever
