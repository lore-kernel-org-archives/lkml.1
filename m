Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0CJGdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 01:33:12 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:48545 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab0CJGdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 01:33:09 -0500
Message-ID: <4B973CF6.4030009@st.com>
Date: Wed, 10 Mar 2010 12:02:22 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Subject: Re: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr 	platform
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com> <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com>
In-Reply-To: <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On 3/10/2010 11:10 AM, Linus Walleij wrote:
> 2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
> 
>>  arch/arm/plat-spear/include/plat/gpt.h |  108 ++++++++++++++++++++++++++++++++
> 
> If this file is only supposed to be used from plat-spear/time.c, move it down
> into plat-spear/gpt.h and #include "gpt.h" so noone else will
> accidentally use it.

GPT's on SPEAr can be used from time.c, platform specific drivers and machine
specific drivers or any driver wishing to use hardware timer.
In first two cases "gpt.h" will work, but in rest of cases we need gpt.h to be
in plat-spear/include/plat

Is it okay?

> 
>> (...)
>>
>> +#ifndef __ASM_PLAT_GPT_H
>> +#define __ASM_PLAT_GPT_H
> 
> This file to macro match i.e. __PLAT_GPT_H again I think...
> (But see below.)

will be changed

> 
>> +
>> +/* register offsets */
>> +#define GPT_CTRL_OFF           0x80 /* Control Register */
>> +#define GPT_INT_OFF            0x84 /* Interrupt Regiset */
>> +#define GPT_LOAD_OFF           0x88 /* Load Register */
>> +#define GPT_COUNT_OFF          0x8C /* Current Count Register */
> 
> Some people want you to do all the indentation e.g. between
> GPT_CTRL_OFF -> 0x80 with TABs only, and I tend to do that
> to keep everybody happy. (This would go for all .h files with
> register definitions.
> 

I have done it the way you said. I don't know what happened to
formatting, even if i see my original patchset, i see tabs and no
spaces. I will take care of this in next version of patchset too.

>> +
>> + * Following functions are exported by gpt.c which can be used by other
>> + * kernel entities
>> + */
>> +int spear_timer_init(struct spear_timer *, int);
>> +
>> +struct spear_timer *spear_timer_request(void);
>> +struct spear_timer *spear_timer_request_specific(int id);
>> +
>> +int spear_timer_free(struct spear_timer *timer);
>> +int spear_timer_enable(struct spear_timer *timer);
>> +int spear_timer_disable(struct spear_timer *timer);
>> +
>> +int spear_timer_get_irq(struct spear_timer *timer);
>> +
>> +struct clk *spear_timer_get_fclk(struct spear_timer *timer);
>> +
>> +int spear_timer_start(struct spear_timer *timer);
>> +int spear_timer_stop(struct spear_timer *timer);
>> +
>> +int spear_timer_set_source(struct spear_timer *timer, int source);
>> +int spear_timer_set_load(struct spear_timer *timer, int autoreload,
>> +               u16 value);
>> +int spear_timer_set_load_start(struct spear_timer *timer, int autoreload,
>> +               u16 value);
>> +int spear_timer_match_irq(struct spear_timer *timer, int enable);
>> +int spear_timer_set_prescaler(struct spear_timer *timer, int prescaler);
>> +
>> +int spear_timer_read_status(struct spear_timer *timer);
>> +int spear_timer_clear_status(struct spear_timer *timer, u16 value);
>> +
>> +int spear_timer_read_counter(struct spear_timer *timer);
>> +
>> +int spear_timer_active(struct spear_timer *);
> 
> Am I right in assuming that this will only ever be used from the plat/timer.c
> file?

This will be used by any module looking to use hardware timer.

> 
> I would contemplate moving away the abstraction API altogether and put
> everything into timer.c, and just hardcode in the timers you're using as
> clocksource and clock event, and put the register definitions and
> offsets from base there as well. This will get down the number of files
> and reduce the forest of files in a nice way.
> 
> If you have some other use of timers that you're planning, the API may
> be justified, please detail the uses you have in mind in that case.
> 
> I know writing APIs is great fun, but sometimes it's easier to read the
> code if you just get rid of them and keep things simple...
> 

Explained earlier.


viresh kumar
