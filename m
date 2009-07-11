Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZGKLHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZGKLHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZGKLGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:06:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:32580 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZGKLGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dqJHCvfFudNp82oAiX3e/3rTDNXwykTc3hXPIae6cVpMP71PPm6cAR6/LNFV/ozDH1
         DQ7Rc74gNp07GDRw6jEDi5CD4Uk8VdRKaVG348a5Hl0LX0jsjqzjZr8BRK5kycerl8Xg
         gCVZAy0TsESA3nXl2zWfB9uSGWTgbIWy8uhe0=
Message-ID: <4A587245.1080304@gmail.com>
Date: Sat, 11 Jul 2009 13:06:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Julia Lawall <julia@diku.dk>, gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>	 <4A584A94.5010105@gmail.com> <1247307444.3032.2.camel@hpdv5.satnam>
In-Reply-To: <1247307444.3032.2.camel@hpdv5.satnam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2009 12:17 PM, Jaswinder Singh Rajput wrote:
> On Sat, 2009-07-11 at 10:17 +0200, Jiri Slaby wrote:
>> On 07/11/2009 09:51 AM, Julia Lawall wrote:
>>> --- a/drivers/staging/otus/wwrap.c
>>> +++ b/drivers/staging/otus/wwrap.c
>>> @@ -1016,12 +1016,13 @@ void kevent(struct work_struct *work)
>>>  {
>>>      struct usbdrv_private *macp =
>>>                 container_of(work, struct usbdrv_private, kevent);
>>> -    zdev_t *dev = macp->device;
>>> +    zdev_t *dev;
>>>  
>>>      if (macp == NULL)
>>>      {
>>>          return;
>>>      }
>>
>> The test is rather useless here.
>>
> 
> Why useless, it should be non-null before setting to dev.

Even if work was NULL, macp won't be NULL.

> But issue is why function name like kevent() is global and who is using
> it.

Since it's not declared, I guess nobody but keventd. It should be static.
