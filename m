Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbXD2B5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbXD2B5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 21:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXD2B5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 21:57:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41962 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbXD2B5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 21:57:21 -0400
Message-ID: <4633FBFF.7050202@oracle.com>
Date: Sat, 28 Apr 2007 18:59:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herbert@gondor.apana.org.au, michal@logix.cz
Subject: Re: [PATCH] crypto: Remove pointless padlock module
References: <4633DB56.6070000@simon.arlott.org.uk>
In-Reply-To: <4633DB56.6070000@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> When this is compiled in it is run too early to do anything useful:
> [    6.052000] padlock: No VIA PadLock drivers have been loaded.
> [    6.052000] padlock: Using VIA PadLock ACE for AES algorithm.
> [    6.052000] padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
> 
> When it's a module it isn't doing anything special, the same 
> functionality can be provided in userspace by "probeall padlock 
> padlock-aes padlock-sha" in modules.conf if it is required.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Michal Ludvig <michal@logix.cz>
> ---
> drivers/crypto/Kconfig   |   16 ++----------
> drivers/crypto/Makefile  |    1 -
> drivers/crypto/padlock.c |   58 
> ----------------------------------------------
> 3 files changed, 3 insertions(+), 72 deletions(-)
> delete mode 100644 drivers/crypto/padlock.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index ff8c4be..f85cecc 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -1,10 +1,10 @@
> menu "Hardware crypto devices"
> 
> config CRYPTO_DEV_PADLOCK
> -    tristate "Support for VIA PadLock ACE"
> -    depends on X86_32
> +    bool "Support for VIA PadLock ACE"
> +    depends on CRYPTO && X86_32

All of drivers/crypto/Kconfig already depends on CRYPTO, so just
	depends on X86_32
should be enough.

> +    default y
>     select CRYPTO_ALGAPI
> -    default m
>     help
>       Some VIA processors come with an integrated crypto engine
>       (so called VIA PadLock ACE, Advanced Cryptography Engine)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
