Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZCGMGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZCGMGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 07:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbZCGMGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 07:06:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:59632 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZCGMGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 07:06:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mPlu/f6CqfD4tffQhomHjpuyIe0WzIgdWGzDuuBhwsnEFLIuSXm7YYOFX/rA8CjQba
         YuU3Rshn3+pTEkbKaqLuf9Y91hFbWRFNqY/CVOXQD3pkZvRYn809U2rZMHd+MVorGAqx
         SQnFn4essX7M9BniFKRpSWBEutnOdxzyQuQz0=
MIME-Version: 1.0
In-Reply-To: <1236418002-2189-2-git-send-email-jirislaby@gmail.com>
References: <1236418002-2189-1-git-send-email-jirislaby@gmail.com>
	 <1236418002-2189-2-git-send-email-jirislaby@gmail.com>
Date: Sat, 7 Mar 2009 14:06:06 +0200
Message-ID: <40f31dec0903070406j65b869fau3359ae8148824d83@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: don't change mac in 
	eeprom_read_mac on error
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/7 Jiri Slaby <jirislaby@gmail.com>:
> Do not touch mac parameter passed to ath5k_eeprom_read_mac unless
> we are sure we have correct address. I.e. when returning error, do
> not change it.
>
> While at it, use '= {}' compiler trick for memsetting mac_d.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <jirislaby@gmail.com>
> Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
> Cc: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/eeprom.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/eeprom.c b/drivers/net/wireless/ath5k/eeprom.c
> index a54ee7e..ac45ca4 100644
> --- a/drivers/net/wireless/ath5k/eeprom.c
> +++ b/drivers/net/wireless/ath5k/eeprom.c
> @@ -1418,14 +1418,11 @@ ath5k_eeprom_init(struct ath5k_hw *ah)
>  */
>  int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
>  {
> -       u8 mac_d[ETH_ALEN];
> +       u8 mac_d[ETH_ALEN] = {};
>        u32 total, offset;
>        u16 data;
>        int octet, ret;
>
> -       memset(mac, 0, ETH_ALEN);
> -       memset(mac_d, 0, ETH_ALEN);
> -
>        ret = ath5k_hw_eeprom_read(ah, 0x20, &data);
>        if (ret)
>                return ret;
> @@ -1441,11 +1438,11 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
>                octet += 2;
>        }
>
> -       memcpy(mac, mac_d, ETH_ALEN);
> -
>        if (!total || total == 3 * 0xffff)
>                return -EINVAL;
>
> +       memcpy(mac, mac_d, ETH_ALEN);
> +
>        return 0;
>  }
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
