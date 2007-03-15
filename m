Return-Path: <linux-kernel-owner+w=401wt.eu-S933461AbXCOLj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbXCOLj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 07:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbXCOLj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 07:39:26 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:46423 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933461AbXCOLjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 07:39:25 -0400
Message-ID: <45F92E97.7030207@boichat.ch>
Date: Thu, 15 Mar 2007 19:31:35 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Cong WANG <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Apple SMC driver (hardware monitoring and control)
References: <45F7C083.7090504@boichat.ch>	 <2375c9f90703140411k1d40d31fx248a438d7b2859c1@mail.gmail.com> <2375c9f90703140700k9fb4606pad0f0dc401764323@mail.gmail.com>
In-Reply-To: <2375c9f90703140700k9fb4606pad0f0dc401764323@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.191.155 (nusnet-191-155.dynip.nus.edu.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Cong WANG wrote:
> 2007/3/14, Cong WANG wrote:
>> I am sorry. I forgot to CC to the list.
>>
>> 2007/3/14, Nicolas Boichat wrote:
>> > Hello,
>> >
>>
>> <snip>
>>
>> > +static ssize_t applesmc_show_fan_manual(struct device *dev, char *buf,
>> > +                                                               int
>> offset)
>> > +{
>> > +       int ret;
>> > +       u16 manual = 0;
>> > +       u8 buffer[2];
>> > +
>> > +       down(&applesmc_sem);
>> > +
>> > +       ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
>> > +       manual = ((buffer[0] << 8 | buffer[1]) >> offset) & 0x01;
>> > +
>> > +       up(&applesmc_sem);
>> > +       if (ret)
>> > +               return ret;
>> > +       else
>> > +               return sprintf(buf, "%d\n", manual);
>> > +}
>> > +
>>
>> I doubt about your last 'sprintf'. Your 'buf' just has only two 'u8's,
>> which maybe only has two bytes, and '\n' already consumes one. So only
>> one byte is left for the decimal vaule of 'manual'. Even it is just
>> less than 10, just as what you want, the final '\0' is omitted!
>>
>> What's more, you can't get such information from the return value of
>> 'sprintf'. So I suggest you to choose 'snprintf' instead.
>>
> 
> Sorry. I thought his 'buffer' as 'buf'. But my suggestion is still
> worthy your thinking.

I'm quite sure using sprintf is ok. At least it's the way sysfs helper
functions are coded in other parts of the kernel too.

I agree that the variable names (buf and buffer) used are quite
confusing though... I'll fix that.

Best regards,

Nicolas
