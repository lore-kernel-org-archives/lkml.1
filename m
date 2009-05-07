Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbZEGKRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbZEGKRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbZEGKR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:17:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:56569 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbZEGKRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NIm7VuhPF8XopgeHZ2X2X8byV+8mVEWtfclsuM4fCiAqcvUkT4pGn8V2yA1NzzKr8p
         /Q5jx33+A2SUGerCsua/NH0WtjUvDCqwETw7VX++4XwpzM2AkrwXZgFHZbQZvj6x4Qy6
         ujFfA8PPr3COZ6VRqvHaBMEb7Ln6ezYlsC9zk=
MIME-Version: 1.0
In-Reply-To: <4d34a0a70905070303r55c2c681yf58680de2f3d4a9f@mail.gmail.com>
References: <4A012C64.1020101@samsung.com>
	 <5d5443650905060638l52b3c17dle0d138b689a23252@mail.gmail.com>
	 <4d34a0a70905070303r55c2c681yf58680de2f3d4a9f@mail.gmail.com>
Date: Thu, 7 May 2009 15:47:24 +0530
Message-ID: <5d5443650905070317pa962440kf6d416f0272decc5@mail.gmail.com>
Subject: Re: Input: add MAX7359 key switch controller driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Kim Kyuwon <chammoru@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>, linux-i2c@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

>>
>> Could you please restrict the commit text line to 80/72 columns? It
>> will look good.
>
> Is this restriction for commit text mandatory? It seems like I got an
> email from Andrew Morton that my patch was wordwraped even commit
> text.

This helps reader of the commit text to not give much stretch on his eyes :)

>>
>>> +
>>> +static int __devinit max7359_probe(struct i2c_client *client,
>>> +                                       const struct i2c_device_id *id)
>>
>> You may want to remove __devinit as it is i2c client driver . I have
>> added linux-i2c for i2c specific review.
>
> Actually I don't want to remove it :), Is there any reason why you think so?

Sorry I have mistaken it as __init. This is fine.

>
>>> +static int max7359_suspend(struct i2c_client *client, pm_message_t mesg)
>>> +{
>>> +       /* If no keys are pressed, enter sleep mode for 8192 ms */
>>> +       max7359_write_reg(client, MAX7359_REG_SLEEP, 0x01);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int max7359_resume(struct i2c_client *client)
>>> +{
>>> +       /* Restore the default setting (autosleep for 256 ms) */
>>> +       max7359_write_reg(client, MAX7359_REG_SLEEP, 0x07);
>>> +
>>> +       return 0;
>>> +}
>>
>> Protect these two function with #ifdef CONFIG_PM please.
>
> This is what I really wanted to ask. I'm trying not to use '#ifdef'.
> By the way, why most of drivers use protect suspend/resume functions
> with #ifdef? Just for saving code size?

suspend and resume is only important if the user of this driver has
CONFIG_PM enabled in it's
defconfig, right? So, if CONFIG_PM is not defined suspend/resume
should equal to NULL.

>>
>>
>>> +};
>>> +
>>> +
>>> +MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
>>> +MODULE_DESCRIPTION("MAX7359 Key Switch Controller Driver");
>>> +MODULE_LICENSE("GPL v2");
>>
>> MODULE_ALIAS ??
>
> In 'include/linux/module.h'
>
>  96 /* For userspace: you can also call me... */
>  97 #define MODULE_ALIAS(_alias) MODULE_INFO(alias, _alias)
>
> From comment above, I think MODULE_ALIAS is optional. Do you still
> think MODULE_ALIAS needs?
>

Yes, it is not __must__.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
