Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYHKWiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYHKWiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYHKWh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:37:57 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2499 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYHKWhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:37:55 -0400
X-BigFish: VPS-21(zz1432R98dR1805M8b9bkzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <48A0BFE3.2060403@am.sony.com>
Date: Mon, 11 Aug 2008 15:40:35 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
References: <489A1844.3090502@am.sony.com> <20080811191012.GA16553@elte.hu> <48A091B7.6050601@zytor.com>
In-Reply-To: <48A091B7.6050601@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2008 22:37:37.0797 (UTC) FILETIME=[DB366B50:01C8FC02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> * Tim Bird <tim.bird@am.sony.com> wrote:
>>
>>> Add support for a built-in command line for x86 architectures. The
>>> Kconfig help gives the major rationale for this addition.
>>
>> i have actually used a local hack quite similar to this to inject boot
>> options into bzImages via randconfig - so i would find this feature
>> rather useful.
>>
>> a small observation:
>>
>>> +    /* append boot loader cmdline to builtin, unless builtin
>>> overrides it */
>>> +    if (builtin_cmdline[0] != '!') {
>>> +        strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
>>> +        strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
>>> +        strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
>>> +    } else {
>>> +        strlcpy(boot_command_line, &builtin_cmdline[1],
>>> +            COMMAND_LINE_SIZE);
>>> +    }
>>
>> the default branch changes existing command lines slightly: it appends
>> a space to them. This could break scripts that rely on the precise
>> contents of /proc/cmdline output. (i have some - they are arguably dodgy)

Yeah, I wasn't too comfortable with that.

>> Best would be to make it really apparent in the code that nothing
>> changes if this config option is not set. Preferably there should be
>> no extra code at all in that case.

Agreed.

> 
> I would like to see this:
> 
> #ifdef CONFIG_BUILTIN_CMDLINE
> # ifdef CONFIG_BUILTIN_CMDLINE_OVERRIDE
>     strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> # else
>     if (boot_command_line) {
>         strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
>         strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
>     }
> # endif
> #endif

You missed copying builtin_cmdline back to boot_command_line, but
in general this looks OK to me.  If nobody objects to the ifdef
multiplicity, I'll work up a version tomorrow for review.  (Sorry,
I'm a bit swamped today.)
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

