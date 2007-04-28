Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXD1XVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXD1XVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXD1XVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:21:14 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:36446 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXD1XVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:21:13 -0400
Message-ID: <4633D6E3.5060602@simon.arlott.org.uk>
Date: Sun, 29 Apr 2007 00:21:07 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herbert@gondor.apana.org.au
Subject: Re: [PATCH] crypto: Use padlock.ko only as a module
References: <463379FA.9080004@simon.arlott.org.uk> <20070428153707.50f1644a.randy.dunlap@oracle.com>
In-Reply-To: <20070428153707.50f1644a.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/07 23:37, Randy Dunlap wrote:
> On Sat, 28 Apr 2007 17:44:42 +0100 Simon Arlott wrote:
> 
>> The padlock.ko module is completely useless when compiled in 
>> because it can't do anything and gets run too early to output 
>> anything useful.
>> --- a/drivers/crypto/Makefile
>> +++ b/drivers/crypto/Makefile
>> @@ -1,4 +1,6 @@
>> -obj-$(CONFIG_CRYPTO_DEV_PADLOCK) += padlock.o
>> +ifeq ($(CONFIG_CRYPTO_DEV_PADLOCK),m)
>> +obj-m += padlock.o
>> +endif
>>  obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
>>  obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
>>  obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
> 
> I think that we prefer to enforce config symbols in Kconfig files,
> not in Makefiles.  E.g.,

No, that would cause the wrong behaviour in this case. The two 
modules that depend on it for no reason work fine compiled in.

Ideally I'd just remove that module completely, all it does is 
trigger the loading of the other two modules when modules are 
used - so I'll submit a patch for that instead.

> ---
>  drivers/crypto/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2621-pv.orig/drivers/crypto/Kconfig
> +++ linux-2621-pv/drivers/crypto/Kconfig
> @@ -2,7 +2,7 @@ menu "Hardware crypto devices"
>  
>  config CRYPTO_DEV_PADLOCK
>  	tristate "Support for VIA PadLock ACE"
> -	depends on X86_32
> +	depends on X86_32 && m
>  	select CRYPTO_ALGAPI
>  	default m
>  	help


-- 
Simon Arlott
