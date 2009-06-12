Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbZFLBVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbZFLBVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZFLBV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:21:28 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:42867 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbZFLBV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G4Hk11XoTVkLFowCstaukthpz4fpvwROqOa6U3lN12K5tqhKekSaDhoVNyn7gEva1M
         MEYrtE2R3BsoELwdEzH5ROnL3EJq9TQxDhDeiYO3tspgQFawWhVzJwaMSfVDclQXzSwe
         6cKll2CKlX2soZU45hwXTwE9Pe1GAJbExBEXE=
MIME-Version: 1.0
In-Reply-To: <20090611144326.GB2572@ucw.cz>
References: <a8e1da0906020254s34dd0cd9id1b88655cab6d72d@mail.gmail.com>
	 <20090611144326.GB2572@ucw.cz>
Date: Fri, 12 Jun 2009 09:21:29 +0800
Message-ID: <a8e1da0906111821h17d11886rfc194b6e22739f63@mail.gmail.com>
Subject: Re: [PATCH] printk: add halt_delay parameter for printk delay in halt 
	phase
From: Dave Young <hidave.darkstar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:43 PM, Pavel Machek<pavel@ucw.cz> wrote:
> On Tue 2009-06-02 17:54:52, Dave Young wrote:
>> Add a halt_delay module parameter in printk.c used to read the printk
>> messages in halt/poweroff/restart phase, delay each printk messages
>> by halt_delay milliseconds. It is useful for debugging if there's no
>> other way to dump kernel messages that time.
>>
>> halt_delay default value is 0, change it by:
>>
>> echo xxx > /sys/module/printk/parameters/halt_delay
>
> Well, stopping oopses from scrolling offscreen was very useful for me
> in past.
>
>> +static inline void halt_delay_msec(void)
>> +{
>> +     if (halt_delay == 0 || !(system_state == SYSTEM_HALT
>> +                             || system_state == SYSTEM_POWER_OFF
>> +                             || system_state == SYSTEM_RESTART))
>> +             return;
>> +
>> +     mdelay(halt_delay);
>
> ...but this will not trigger for oops, right?

Hi, Pavel, this is for halt phase only.

Andrew suggest to make it a general feature, thus we can enable printk
delay when we want. I will write a new patch for that.

>                                                                Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Regards
dave
