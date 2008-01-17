Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYAQRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYAQRGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYAQRGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:06:12 -0500
Received: from free-electrons.com ([88.191.23.47]:34076 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYAQRGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:06:11 -0500
Message-ID: <478F8AEC.1080209@free-electrons.com>
Date: Thu, 17 Jan 2008 18:05:48 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c	compiling
References: <200801171643.49301.michael-lists@free-electrons.com> <1200587774.5332.11.camel@cinder.waste.org>
In-Reply-To: <1200587774.5332.11.camel@cinder.waste.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

Thanks for your feedback!

On 01/17/2008 05:36 PM, Matt Mackall wrote:
> On Thu, 2008-01-17 at 16:43 +0100, Michael Opdenacker wrote:
>   
>> diff -Naur linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32 linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32
>> --- linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32	2008-01-17 09:48:58.000000000 +0100
>> +++ linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32	2008-01-17 10:06:56.000000000 +0100
>> @@ -45,10 +45,13 @@
>>  
>>  obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
>>  obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
>> -obj-y				+= pcspeaker.o
>> -
>>  obj-$(CONFIG_SCx200)		+= scx200_32.o
>>  
>> +ifeq ($(CONFIG_INPUT_PCSPKR),y)
>> +	obj-y			+= pcspeaker.o
>> +endif
>>     
>
> I'm not sure this does what you want. What if CONFIG_INPUT_PCSPKR = m?
>   
Does it make sense to compile arch/x86/kernel/pcspeaker.c as a module?
It defines no init and exit functions, and it defines an initcall, which
only makes sense at boot time.

That's why I didn't use
obj-$(CONFIG_INPUT_PCSPKR)+=pcspeaker.o

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

