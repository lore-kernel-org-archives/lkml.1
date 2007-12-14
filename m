Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbXLNOhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbXLNOhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXLNOhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:37:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:22892 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbXLNOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:37:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=e/C/q5hjcf+oXUADY7FjasaLQstrcunmBGfiPNQNxsK7UrG+bM/aJ+89lQXwKDV0XbzGvbIlbLsa44n2T8qdycuc9qkVB9r6AWCKf/WaIunEas/Ln54lDvnozOVjirzV2HJXzOPS9+NFkNkGWUiVXfBpTt6HTXQGo7t5PEBO2XA=
Message-ID: <476294D3.4060609@keyaccess.nl>
Date: Fri, 14 Dec 2007 15:36:03 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rene Herman <rene.herman@gmail.com>, "David P. Reed" <dpreed@reed.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1181682498.8176.224.camel@chaos> <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <476250D5.8000409@gmail.com> <20071214142355.GA10130@elte.hu>
In-Reply-To: <20071214142355.GA10130@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-12-07 15:23, Ingo Molnar wrote:

> * Rene Herman <rene.herman@gmail.com> wrote:
> 
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -229,10 +229,9 @@ static int __init obsolete_checksetup(char *line)
>>  }
>>
>>  /*
>> - * This should be approx 2 Bo*oMips to start (note initial shift), and will
>> - * still work even if initially too large, it will just take slightly longer
>> + * Initial value roughly corresponds to a 1 GHz CPU
>>   */
>> -unsigned long loops_per_jiffy = (1<<12);
>> +unsigned long loops_per_jiffy = 1000000000 / HZ;
>>
>>  EXPORT_SYMBOL(loops_per_jiffy);
> 
> this is a factor of ~2400 increase - this will take an eternity to boot 
> on any older CPU.

Only any outb_p's used before loops_per_jiffy is calibrated are affected.

This pre-calibation thing is what's historically held this change back (it's 
been discussed dozens of times before). At 4096, not any machine is going to 
have an appreciable delay before calibration when switching from the outb to 
  0x80.

Rene.
