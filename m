Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbXERDYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbXERDYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbXERDYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:24:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:54289 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXERDYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qZNRnFc5b7de3h85uC1Kf1LyajV9lupYXDFTsCbQRQ0hYq9U0gpVAyE8om5wFKSIIvXSTg5hcUcNSejKuuVqgn/u1Po9YuBA5B+Vcr2oX9WxgIhLsLDnlZQpeii1mcYVJKPi5xQQK2cMrV+w7Oy71iBMrWsAZZT9LV6T4O02pQc=
Message-ID: <787b0d920705172024g723412b4n8f82d3cd78e0f702@mail.gmail.com>
Date: Thu, 17 May 2007 23:24:15 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: galak@kernel.crashing.org, tglx@linutronix.de, mingo@elte.hu,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       sshtylyov@ru.mvista.com
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov writes:
> Kumar Gala wrote:
>> [Sergei Shtylyov]
>>> Kumar Gala wrote:

>>>> I haven't looked at all the new clock/timer code, is there any
>>>> utility in having support for more than one clock source?
>>>
>>> Of course, you may register as many as you like.
>>
>> Sure, but is there any utility in registering more than the
>> decrementer on PPC?
>
> Not yet. I'm not sure I know any other PPC CPU facility fitting
> for clockevents. In theory, FIT could be used -- but its period
> is measured in powers of 2, IIRC.

I'd really like to have that as an option. It would allow oprofile
to safely use hardware events on the MPC74xx "G4" processors.
Alternately it would allow thermal events. It is safe to use at
most one of the three (decrementer,profiling,thermal) interrupts.
If two were to hit at the same time, badness happens.

It's possible to wrapper the interrupt in something that divides
down, calling the normal code only some of the time. I think one
of the FIT choices is about 4 kHz on my system, which would be OK.

Full oprofile functionality would be wonderful.
