Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYIWNkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYIWNkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYIWNkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:40:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:5932 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYIWNkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=HHVkESpIPRJSsAjrgN0/tWikPDKosAVgXh7i+Op5y0MdrcxEMDkowE75vcyEXOs1YJ
         sN8nq8Pt8rafsT5/kPkT7z6GCu4tpy9qbR/m+4QlF+2HedXRJCFUPVBwAfbWuxWJB/2I
         hSr1e9Q52bhoDoFhI0sXSR64fWqwyu8QfWTZo=
Message-ID: <9ea470500809230640m2f1da3e0l944f7b4101900f67@mail.gmail.com>
Date: Tue, 23 Sep 2008 15:40:08 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Mark de Wever" <koraq@xs4all.nl>
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Cc: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Gadi Oxman" <gadio@netvision.net.il>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48D8B6ED.6020407@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com>
	 <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com>
	 <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com>
	 <20080923074845.GB5656@gollum.tnic> <48D8B6ED.6020407@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:29 AM, Sergei Shtylyov
<sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Borislav Petkov wrote:
>
>>>> Only not sure whether the static is the best solution, the following
>>>> patch also works, by zeroing the memory as you suggested.
>>>>
>>>> Signed-off-by: Mark de Wever <koraq@xs4all.nl>
>>>>
>>>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>>>> index 1bce84b..c41f5b1 100644
>>>> --- a/drivers/ide/ide-tape.c
>>>> +++ b/drivers/ide/ide-tape.c
>>>> @@ -2338,7 +2338,7 @@ static void
>>>> idetape_get_inquiry_results(ide_drive_t *drive)
>>>>  {
>>>>        idetape_tape_t *tape = drive->driver_data;
>>>>        struct ide_atapi_pc pc;
>>>> -       char fw_rev[6], vendor_id[10], product_id[18];
>>>> +       char fw_rev[6] = {'\0'}, vendor_id[10] = {'\0'}, product_id[18]
>>>> = {'\0'};
>>>>
>>>
>>>  Do you realize how much *absolutely unnecessary* code will this bring
>>>  in? This is certainly worse than your initial patch (if it was correct).
>>>
>>
>> Yep, Sergei's right. Both of our patches are dumb.
>>
>>
>>>
>>> Ugh, looks like I'll have t submit the patch myself to stop this
>>> ugliness...
>>>
>>
>> Is this what you had in mind?
>>
>
>  Sure.

Mark, can you please test?

Thanks.

-- 
Regards/Gruss,
Boris
