Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbYEXU7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbYEXU7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbYEXU7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:59:18 -0400
Received: from gw.goop.org ([64.81.55.164]:32783 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395AbYEXU7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:59:17 -0400
Message-ID: <48388187.2070503@goop.org>
Date: Sat, 24 May 2008 21:58:47 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Tom Spink <tspink@gmail.com>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
References: <20080524192540.GA28067@uranus.ravnborg.org> <48387F0B.3020506@goop.org>
In-Reply-To: <48387F0B.3020506@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
>> We have many places in the kernel that looks like
>> the following:
>>
>> #ifdef CONFIG_FOO
>>     ...
>> #endif
>>
>> Which has the disadvantage that the code denoted '...'
>> are not even built if CONFIG_FOO is not selected in
>> the current configuration.
>>
>> We know that gcc do simple code-elimination for
>> conditionals which is always true/false and
>> thus the above code could be turned into:
>>
>>     if (CONFIG_FOO)
>>         ...
>>
>> One line smaller and we follow the normal flow in the program.
>> The code is always build but we do not waste space as gcc will
>> do proper code-elimination for us.
>>
>> Today this is not possible because kconfig will only
>> define CONFIG_FOO if selected and FOO is not a module.
>>
>> The following patch implement a new set of defines in
>> the KCONFIG_* namespace.
>>
>> For a tristate symbol the following are defined:
>>
>> FOO not selected: #define KCONFIG_FOO        0
>> #define KCONFIG_FOO_MODULE 0
>>
>> FOO is built-in ('y')
>> #define KCONFIG_FOO        1
>> #define KCONFIG_FOO_MODULE 0
>>
>> FOO is a module ('m'):
>> #define KCONFIG_FOO        1
>> #define KCONFIG_FOO_MODULE 1
>>
>> In other words KCONFIG_FOO will say if the
>> symbol is selected and KCONFIG_FOO_MODULE
>> will say if it is a module.
>>
>> With the above included we can now do:
>>
>>     if (KCONFIG_FOO)
>>         ...
>>
>> This is not a replacement for the CONFIG_*
>> defines but a pleasant supplement.
>> Using KCONFIG_FOO will also give us a nice
>> error message the day that FOO is no longer part
>> of the configuration.
>>   
>
> How about rather than defining a pile of new constants, we just define:
>
> #define KCONFIG(x)   (x - 0)      /* XXX choose better macro name */

Would

    #define KCONFIG(x)   (CONFIG_##x - 0)

    if (KCONFIG(PREEMPT)) {
        ...
    }

work?

    J
