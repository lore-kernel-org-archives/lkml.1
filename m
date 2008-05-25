Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYEYABC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYEYABC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 20:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYEYAAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 20:00:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:26857 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYEYAAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 20:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RrGmEjPLRRyl4sqP+KvQ2t2lUWxfeunLPTnm1erTt7UREKSsHe9rqZHowdtP/HuSPn59v//K9ISOc9hfmq6u6TAVOult7piGiaqcsgwPjz4LXbUBUnXRA8HG2lmbAsRfQ15FB+ZeziF3HFGWBDrw2DABwmWYV6x679TBwgAvdFY=
Message-ID: <7b9198260805241700o2bc38848m60d5853b63e6ff26@mail.gmail.com>
Date: Sun, 25 May 2008 01:00:51 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Steven Fuerst" <sfuerst@stanford.edu>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200805241636.22242.sfuerst@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200805241636.22242.sfuerst@stanford.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/25 Steven Fuerst <sfuerst@stanford.edu>:
>
>> On Sat, May 24, 2008 at 09:58:47PM +0100, Jeremy Fitzhardinge wrote:
>> >
>> > Would
>> >
>> > #define KCONFIG(x) (CONFIG_##x - 0)
>> >
>> > if (KCONFIG(PREEMPT)) {
>> > ...
>> > }
>> >
>> > work?
>>
>> $ cat test.c
>> #define KCONFIG(x) (CONFIG_##x - 0)
>>
>> int main()
>> {
>> if (KCONFIG(PREEMPT))
>> ;
>>
>> return 0;
>> }
>> $ gcc -O2 -Wall test.c
>> test.c: In function âmainâ:
>> test.c:5: error: âCONFIG_PREEMPTâ undeclared (first use in this function)
>> test.c:5: error: (Each undeclared identifier is reported only once
>> test.c:5: error: for each function it appears in.)
>> $ gcc --version
>> gcc (Debian 4.3.0-5) 4.3.1 20080523 (prerelease)
>>
>> > J
>>
>> cu
>> Adrian
>
> How about this?
>
> #include <stdio.h>
>
> #define CONFIG_FOO      1
> /* #define CONFIG_BAR   1 */
>
> #define STR2(x) #x
> #define STR(x) STR2(x)
>
> #define PASTE2(x, y) x##y
> #define PASTE(x, y) PASTE2(x, y)
>
> #define KCONFIG2(x, y) STR(PASTE(CONFIG_, x))[y]
> #define KCONFIG(x) (!((KCONFIG2(x, 0) == 'C') && \
>                                        (KCONFIG2(x, 1) == 'O') && \
>                                        (KCONFIG2(x, 2) == 'N') && \
>                                        (KCONFIG2(x, 3) == 'F') && \
>                                        (KCONFIG2(x, 4) == 'I') && \
>                                        (KCONFIG2(x, 5) == 'G') && \
>                                        (KCONFIG2(x, 6) == '_')))
>
> int main()
> {
>        if (KCONFIG(FOO)) printf("FOO\n");
>        if (KCONFIG(BAR)) printf("BAR\n");
>        return 0;
> }
>
>
> It of course assumes that the result of all defined macros you want to test
> for do not start with "CONFIG_", so this doesn't work generally.  However,
> nearly all of the time the arguement to KCONFIG() will be defined to be "1"
> an integer, or some other known string that doesn't begin with "CONFIG_", so
> this trick is fairly robust.

I've seen worse abuse of the preprocessor[1]. ;-)

> Steven

-- 
Tom Spink

[1] http://www.ioccc.org/
