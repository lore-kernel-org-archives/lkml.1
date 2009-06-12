Return-Path: <linux-kernel-owner+w=401wt.eu-S933394AbZFLKHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394AbZFLKHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbZFLKHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:07:36 -0400
Received: from mout0.freenet.de ([195.4.92.90]:54555 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbZFLKHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:07:35 -0400
Message-ID: <4A3228CB.9000009@freenet.de>
Date: Fri, 12 Jun 2009 12:07:07 +0200
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH: README - Fix misleading pointer to the defconf directory
References: <4A321A3C.6030400@gmx.de> <200906121150.40332.arnd@arndb.de>
In-Reply-To: <200906121150.40332.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 12 June 2009, Patrick Ringl wrote:
>   
>> the README simply points to a wrong/non-existent directory where the default
>> configurations are not suited, hence the patch.
>>     
>
> On six architectures, it's still the right directory, your patch breaks it.
>
>   
Darn, I used 'find' to ensure the structure is consistent, stupidly I 
didn't check wether the amount of fitting cases equals the amount of 
platforms at all, thus I did miss those who do not fit.
>> Signed-off-by: Patrick Ringl <patrick_@freenet.de>
>>
>> --- linux.orig/README   2009-06-10 05:05:27.000000000 +0200
>> +++ linux/README        2009-06-12 10:46:15.000000000 +0200
>> @@ -175,7 +175,7 @@
>>                            Like above, but avoids cluttering the screen
>>                            with questions already answered.
>>         "make defconfig"   Create a ./.config file by using the default
>> -                          symbol values from arch/$ARCH/defconfig.
>> +                          symbol values from arch/$ARCH/configs/*_defconfig.
>>         "make allyesconfig"
>>                            Create a ./.config file by setting symbol
>>                            values to 'y' as much as possible.
>>     
>
> You could write e.g.
>
> 	default symbol values from one of arch/{$ARCH}/defconfig or
> 	arch/${ARCH}/configs/${PLATFORM}_defconfig, depending on
> 	the architecture.
>
> It would also be consistent to list the specific defconfigs here, like
>
> 	"make ${PLATFORM}_defconfig"
> 			Create a ./.config file by using the default
> 			symbol values from
> 			arch/${ARCH}/configs/${PLATFORM}_defconfig.
> 			Use "make help" to see a list of the available
> 			platforms on your architecture.
>
>   
I really like that approach! :-)
> Not also that your patch should be merged through a subsystem maintainer.
> If you don't know who that is, use scripts/get_maintainer.pl.
> For scripts/kconfig/* and README it suggests sending it to Sam, Roman and
> linux-kbuild@vger.kernel.org, which sounds right.
>
> 	Arnd <>
Right, I honestly didn't know about that useful tool (if the LKML-FAQ 
tells about this, I must've missed it). Thanks for your short review and 
the revealing of my overhasty blooper.

I am going to resend the patch with your suggestions above soon.


regards,
Patrick
