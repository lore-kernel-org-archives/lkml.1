Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0CLIqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:46:07 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50838 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab0CLIqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:46:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LjuUKvuXpyv+JB8WWCFnTc1eItIunANu2dftSSOFdwIVzLdl4J1DeF+wkEbSI4mzqf
         nmmcVtRGJxlGm/s/diXLyxu/w1U2fAjviC1FVVUYbncOAixbluux/M5KSv7xYKiyk1Ub
         F5owH9KJpEUuOsoUYsN+6nmQ2U02zhlJXiFn4=
MIME-Version: 1.0
In-Reply-To: <4B98C371.7050500@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
	 <63386a3d1003102300q23ea536bje956f8d5c7e333a2@mail.gmail.com>
	 <4B98C371.7050500@st.com>
Date: Fri, 12 Mar 2010 09:46:02 +0100
Message-ID: <63386a3d1003120046g2f83ace7s150441daa8bd6892@mail.gmail.com>
Subject: Re: [PATCH 05/11] ST SPEAr: Added clock framework for SPEAr platform 
	and machines
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Shiraz HASHIM <shiraz.hashim@st.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/11 Shiraz HASHIM <shiraz.hashim@st.com>:
> On 3/11/2010 12:30 PM, Linus Walleij wrote:
>> 2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
>> (...)
>>> +       if (unlikely(clk->flags & RESET_TO_ENABLE))
>>> +               val &= ~(1 << clk->en_reg_bit);
>>> +       else
>>> +               val |= 1 << clk->en_reg_bit;
>>> +       writel(val, clk->en_reg);
>>
>> I don't understand one bit of this. (...)
>
> The intention to use RESET_TO_ENABLE flag is to generalize clock
> enable/disable across platforms.

I misread the entire thing, there was some bad parsing inside my head...
Sorry about this.

>> OMAP uses CPUfreq but that is really about the CPU. As it happens, all
>> their clk:s always change frequency at the same operating points as the
>> CPU. So they can have pre/post calls from CPUfreq in their code, but
>> this will not work with things like PrimeCells where other users of the cell
>> may not have operating points correlated with CPU operating points.
>>
>> (I'm not requesting you to solve this problem, more to be aware of it.)
>
> I think generally in embedded systems (at least in our case :) ) the CPU clock
> itself is not completly independent. It is generally tied with some system
> clock, which has an impact on bus and peripheral clocks. In that sense cpu freq
> would be a better mean to notify frequency change.
> In any case, clock framework don't intend to do it. It only need to reflect
> correct system state. Is this understanding correct?

Currently it's like that but I think clk really needs a frequency change
notification mechanism. I will have to deal with it some day I think :-/

Yours,
Linus Walleij
