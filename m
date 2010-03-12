Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0CLFUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 00:20:07 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:33379 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab0CLFUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 00:20:04 -0500
Message-ID: <4B99CECF.5030502@st.com>
Date: Fri, 12 Mar 2010 10:49:11 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/11] ST SPEAr: Added source files for SPEAr3xx	machine
 family
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <1267592861-26911-3-git-send-email-viresh.kumar@st.com> <1267592861-26911-4-git-send-email-viresh.kumar@st.com> <1267592861-26911-5-git-send-email-viresh.kumar@st.com> <1267592861-26911-6-git-send-email-viresh.kumar@st.com> <1267592861-26911-7-git-send-email-viresh.kumar@st.com> <1267592861-26911-8-git-send-email-viresh.kumar@st.com> <63386a3d1003082246g2752ccf4ob52d5bb01dfb264c@mail.gmail.com> <20100311104103.GC16376@n2100.arm.linux.org.uk>
In-Reply-To: <20100311104103.GC16376@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2010 4:11 PM, Russell King - ARM Linux wrote:
> On Tue, Mar 09, 2010 at 07:46:10AM +0100, Linus Walleij wrote:
>>> +struct amba_device uart_device = {
>>> +       .dev = {
>>> +               .init_name = "uart",
>>> +               },
>>> +       .res = {
>>> +               .start = SPEAR3XX_ICM1_UART_BASE,
>>> +               .end = SPEAR3XX_ICM1_UART_BASE + SPEAR3XX_ICM1_UART_SIZE - 1,
>>> +               .flags = IORESOURCE_MEM,
>>> +               },
>>> +       .irq = {IRQ_UART, NO_IRQ},
>>> +       .periphid = 0x00041011,
>>> +};
>>
>> You're hardcoding the PrimeCell ID to the ARM version, but I suspect
>> you have an ST derivate with some additional features. If you look in
>> the PL011 driver in drivers/serial/amba-pl011.c you will probably recognize
>> the modified PrimeCell IDs for vendor 0x80 (VENDOR_ST) and I think
>> you might rather need to patch this file with your new periphid and
>> possibly even implement some new extensions (if there are any).
>>
>> What value is actually in the ID registers of your cell? (Just
>> check in some debugger or simply printk() it...)
> 
> There is no need to specify the ID when the device provides it - in fact
> the code will override you by reading the ID from the device if it finds
> it.  The only reason to explicitly provide one is for the very early
> Primecell devices which didn't implement the ID scheme - such as PL010.
> 

It is Removed.
