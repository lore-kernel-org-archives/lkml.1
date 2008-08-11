Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYHKTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYHKTYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYHKTYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:24:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37457 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbYHKTYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:24:10 -0400
Message-ID: <48A091B7.6050601@zytor.com>
Date: Mon, 11 Aug 2008 12:23:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
References: <489A1844.3090502@am.sony.com> <20080811191012.GA16553@elte.hu>
In-Reply-To: <20080811191012.GA16553@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tim Bird <tim.bird@am.sony.com> wrote:
> 
>> Add support for a built-in command line for x86 architectures. The 
>> Kconfig help gives the major rationale for this addition.
> 
> i have actually used a local hack quite similar to this to inject boot 
> options into bzImages via randconfig - so i would find this feature 
> rather useful.
> 
> a small observation:
> 
>> +	/* append boot loader cmdline to builtin, unless builtin overrides it */
>> +	if (builtin_cmdline[0] != '!') {
>> +		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
>> +		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
>> +		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
>> +	} else {
>> +		strlcpy(boot_command_line, &builtin_cmdline[1],
>> +			COMMAND_LINE_SIZE);
>> +	}
> 
> the default branch changes existing command lines slightly: it appends a 
> space to them. This could break scripts that rely on the precise 
> contents of /proc/cmdline output. (i have some - they are arguably 
> dodgy)
> 
> Best would be to make it really apparent in the code that nothing 
> changes if this config option is not set. Preferably there should be no 
> extra code at all in that case.
> 

I would like to see this:

#ifdef CONFIG_BUILTIN_CMDLINE
# ifdef CONFIG_BUILTIN_CMDLINE_OVERRIDE
	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
# else
	if (boot_command_line) {
		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
	}
# endif
#endif

	-hpa

		
