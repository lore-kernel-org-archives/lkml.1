Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbZEOEcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbZEOEcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZEOEcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:32:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:17215 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZEOEcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rdN/5hRKZAaWldH/lYDLohp7all5iSsKUz65lpr1pEdxfnjtXQ7BnTP2xLevpH61iA
         L0fmWhIyjwaeLSC/L5tfy34xy/oIXGN5/DS3Rz7VHt07xjsqLVps1MBq2fyG/Q4TM1EH
         iAY8HeXl6UIPh9kBWetIh8vkhvRhIH+VtbZuc=
MIME-Version: 1.0
In-Reply-To: <20090514103731.GA23814@roarinelk.homelinux.net>
References: <20090514100909.GA23626@roarinelk.homelinux.net>
	 <5d5443650905140328v319e673o2f7b865e21619486@mail.gmail.com>
	 <20090514103731.GA23814@roarinelk.homelinux.net>
Date: Fri, 15 May 2009 13:32:43 +0900
Message-ID: <483a38b80905142132q7642c57w1d12812bda6f845@mail.gmail.com>
Subject: Re: [PATCH] TSC2007: private data for platform callbacks.
From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Trilok Soni <soni.trilok@gmail.com>, Kwangwoo Lee <kwlee@mtekvision.com>,
       linux-kernel@vger.kernel.org,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 7:37 PM, Manuel Lauss
<mano@roarinelk.homelinux.net> wrote:
> Hi Trilok,
>
> On Thu, May 14, 2009 at 03:58:19PM +0530, Trilok Soni wrote:
>> CCing linux-input mailing list, so not deleting any code from this
>> e-mail while replying.
>>
>> On Thu, May 14, 2009 at 3:39 PM, Manuel Lauss
>> <mano@roarinelk.homelinux.net> wrote:
>> > Add a private data field to the tsc2007 platform data and pass this
>> > to the callbacks.
>>
>> I hope that you have created this patch on top of two recently posted
>> patches by Kwangwoo Lee
>> to merge changes from Thierry.
>
> No; it's against Linux's git. Will rediff.
>
>
>
>> > - ? ? ? int ? ? ? ? ? ? ? ? ? ? (*get_pendown_state)(void);
>> > - ? ? ? void ? ? ? ? ? ? ? ? ? ?(*clear_penirq)(void);
>> > + ? ? ? struct tsc2007_platform_data *pd;
>> > ?};
>> >
>> > +/* ask platform for pendown state */
>> > +static inline int ts_get_pendown_state(struct tsc2007 *ts)
>> > +{
>> > + ? ? ? return ts->pd->get_pendown_state(ts->pd->priv);
>>
>> So, we don't need check here, like this:
>>
>> if (ts->pd->get_pendown_state)
>>           ret =  ts->pd->get_pendown_state(ts->pd->priv);
>
> The driver doesn't work right without that callback so the check
> in here is kind of pointless. Better to check for it in the
> probe function and refuse to probe if it isn't there.  All other
> callbacks seem optional to me.

I agree. This function should be checked in the probe one.

>
>
>> > ? ? ? ?struct tsc2007 *ts;
>> > - ? ? ? struct tsc2007_platform_data *pdata = pdata = client->dev.platform_data;
>> > + ? ? ? struct tsc2007_platform_data *pdata = client->dev.platform_data;
>>
>> This change shows that you need to rebase based on two patches
>> submitted by Lee recently.
>
> Ah, that shouldn't be in there in the first place.

This should be fixed.

>
> Thanks!
>        Manuel Lauss
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Thanks,

-- 
Kwangwoo Lee <kwangwoo.lee@gmail.com>
