Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZABSk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZABSk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZABSkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:40:19 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:31336 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZABSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:40:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tVbslqbVYEq5ZikTWte7y/4ViP9cTsOYC5cTwWlmfzxi0y9RmTW8P32QYvgWxOA5vI
         uSYPEKShPoqJmFcqdpv2CSXwMwkinzJO3BjXc5LAlw/mDQH9hfXrJfNQAlv1cODaDYeD
         xii5B3Yq8ICYDdGQAH/oTuAwom7riAnJEAkJ8=
Message-ID: <3f9a31f40901021040l2afb5e19sc37e61d3f9728531@mail.gmail.com>
Date: Sat, 3 Jan 2009 00:10:16 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: tip - Solution of ath9k: turn off temporarily (66b5c4a2c638b5a69d3e41abe4a2bae55035a92e)
Cc: "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
In-Reply-To: <20090102180730.GA10072@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40901020936l4bed87e2jb64678572d2ad45b@mail.gmail.com>
	 <20090102180730.GA10072@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 11:37 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>
>> Hello Ingo,
>>
>> If you choose :
>> CONFIG_RFKILL=m
>> CONFIG_ATH9K=y
>>
>> It will give linking error because ATH9K need RFKILL functions.
>>
>> But if you choose :
>>  CONFIG_RFKILL=y
>>  CONFIG_ATH9K=y
>>
>> OR
>>
>>  CONFIG_RFKILL=m
>>  CONFIG_ATH9K=m
>>
>> It is OK.
>
> this was just a quick hatchet job to make the build regression go away.
> Would you like to send a real fix, with the wireless list and maintainers
> Cc-ed? Then i can revert the hack below from tip/out-of-tree.
>
>        ngo
>
> ------------------>
> From 66b5c4a2c638b5a69d3e41abe4a2bae55035a92e Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 2 Jan 2009 16:04:03 +0100
> Subject: [PATCH] ath9k: turn off temporarily
>
> Impact: fix build failure
>
> ath9k fails to build:
>
>  drivers/built-in.o: In function `ath_detach':
>  main.c:(.text+0x16720b): undefined reference to `rfkill_unregister'
>  drivers/built-in.o: In function `ath_rfkill_poll':
>  main.c:(.text+0x167801): undefined reference to `rfkill_force_state'
>  drivers/built-in.o: In function `ath9k_start':
>  main.c:(.text+0x167f01): undefined reference to `rfkill_register'
>  main.c:(.text+0x167f11): undefined reference to `rfkill_free'
>  drivers/built-in.o: In function `ath_pci_probe':
>  main.c:(.text+0x169754): undefined reference to `rfkill_allocate'
>
> when:
>
>  CONFIG_RFKILL=m
>  CONFIG_ATH9K=y
> ---
>  drivers/net/wireless/ath9k/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath9k/Kconfig
> index c43bd32..b849a45 100644
> --- a/drivers/net/wireless/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath9k/Kconfig
> @@ -1,6 +1,8 @@
>  config ATH9K
>        tristate "Atheros 802.11n wireless cards support"
>        depends on PCI && MAC80211 && WLAN_80211
> +       # build failures
> +       depends on 0
>        select MAC80211_LEDS
>        select LEDS_CLASS
>        select NEW_LEDS
>

OK , I CCed to wireless and lets wait for solution :-)

JSR
