Return-Path: <linux-kernel-owner+w=401wt.eu-S1764057AbYJMKLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764057AbYJMKLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762138AbYJMJwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:52:05 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46726 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764286AbYJMJwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=neVfHdQ3OUsKyBamz29/9zP+jltrrGMxDSDKMmTYbpkHjDGOOAkMdFJMF2I5+cbqhP
         Em9ZW9j5iBMkEG3SJRf5fVsoh9LUEHRi8mDivfrTJxiSsh8wJkFJLjeN4tazFD9qKv7H
         OTWrEd3u2d2gyrl2axAM8BW9IER9Ac0DJKzb4=
Message-ID: <386072610810130252s52c11423r69851740975ff517@mail.gmail.com>
Date: Mon, 13 Oct 2008 17:52:00 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Javier Herrero" <jherrero@hvsistemas.es>
Subject: Re: [PATCH 1/1] netdev: DM9000: Added typecasting to supress some warnings on Blackfin
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48F314B7.3020708@hvsistemas.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1223889009-31336-1-git-send-email-cooloney@kernel.org>
	 <20081013091725.GG31627@trinity.fluff.org>
	 <48F314B7.3020708@hvsistemas.es>
X-Google-Sender-Auth: d34d1d7522492440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 5:28 PM, Javier Herrero <jherrero@hvsistemas.es> wrote:
> Hi, Bryan,
>
> So it seems that we must correct that in other place?
>

Yes, we need to check the I/O read_write functions.

-Bryan

> Regards,
>
> Javier
>
> Ben Dooks escribió:
>>
>> On Mon, Oct 13, 2008 at 05:10:09PM +0800, Bryan Wu wrote:
>>>
>>> From: Javier Herrero <jherrero@hvsistemas.es>
>>
>> No, your arch definitions of writesb and co are wrong if they
>> are not taking 'void __iomem *' arguments.
>>
>>>
>>> Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
>>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>>> ---
>>>  drivers/net/dm9000.c |   12 ++++++------
>>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
>>> index f42c23f..c4737ca 100644
>>> --- a/drivers/net/dm9000.c
>>> +++ b/drivers/net/dm9000.c
>>> @@ -188,35 +188,35 @@ iow(board_info_t * db, int reg, int value)
>>>   static void dm9000_outblk_8bit(void __iomem *reg, void *data, int
>>> count)
>>>  {
>>> -       writesb(reg, data, count);
>>> +       writesb((int)reg, data, count);
>>>  }
>>>   static void dm9000_outblk_16bit(void __iomem *reg, void *data, int
>>> count)
>>>  {
>>> -       writesw(reg, data, (count+1) >> 1);
>>> +       writesw((int)reg, data, (count+1) >> 1);
>>>  }
>>>   static void dm9000_outblk_32bit(void __iomem *reg, void *data, int
>>> count)
>>>  {
>>> -       writesl(reg, data, (count+3) >> 2);
>>> +       writesl((int)reg, data, (count+3) >> 2);
>>>  }
>>>   /* input block from chip to memory */
>>>   static void dm9000_inblk_8bit(void __iomem *reg, void *data, int count)
>>>  {
>>> -       readsb(reg, data, count);
>>> +       readsb((int)reg, data, count);
>>>  }
>>>    static void dm9000_inblk_16bit(void __iomem *reg, void *data, int
>>> count)
>>>  {
>>> -       readsw(reg, data, (count+1) >> 1);
>>> +       readsw((int)reg, data, (count+1) >> 1);
>>>  }
>>>   static void dm9000_inblk_32bit(void __iomem *reg, void *data, int
>>> count)
>>>  {
>>> -       readsl(reg, data, (count+3) >> 2);
>>> +       readsl((int)reg, data, (count+3) >> 2);
>>>  }
>>>   /* dump block from chip to null */
>>> --
>>> 1.5.6
>>
>
> --
> ------------------------------------------------------------------------
> Javier Herrero                            EMAIL: jherrero@hvsistemas.com
> HV Sistemas S.L.                          PHONE:         +34 949 336 806
> Los Charcones, 17A                        FAX:           +34 949 336 792
> 19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com
>
>
