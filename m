Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZKWTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZKWTj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZKWTj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:39:28 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:55444 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbZKWTjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:39:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DmObxJaESZ/Y56xqbT7Oz3Yi3knba0WL8AzcYRAhaxqjf+MOi2H4oiFSGph+hNEdw0
         7YEfUWUJnLjaZnd9PsS+Gr4SZl12C71pEdoCSifGc4PzPiagl7of/ALrRv3SVFlJ4Qv2
         WCSnAIofowkLAz6G0R2nX4VPAjTogrqQtiTYw=
MIME-Version: 1.0
In-Reply-To: <4B094B46.8070901@gmail.com>
References: <4B083EE2.9040301@gmail.com> <4B094B46.8070901@gmail.com>
Date: Mon, 23 Nov 2009 11:39:30 -0800
X-Google-Sender-Auth: 6b7b92dcce8081c8
Message-ID: <9929d2390911231139i4f5d5b74i92f8562d01c4159a@mail.gmail.com>
Subject: Re: [PATCH] e1000e: Use sizeof struct rather than pointer in 
	e1000_get_eeprom()
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 06:31, Roel Kluin <roel.kluin@gmail.com> wrote:
> Don't use the sizeof the pointer to clear the result
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/net/e1000e/ethtool.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
>> -             memset(eeprom_buff, 0xff, sizeof(eeprom_buff));
>> +             memset(eeprom_buff, 0xff, sizeof(*eeprom_buff));
>
> No it's probably still not correct, eeprom_buff was kmalloc'd with:
>
> eeprom_buff = kmalloc(sizeof(u16) *
>                        (last_word - first_word + 1), GFP_KERNEL);
>
> How about:
>
> diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
> index 1bf4d2a..5b276c0 100644
> --- a/drivers/net/e1000e/ethtool.c
> +++ b/drivers/net/e1000e/ethtool.c
> @@ -508,7 +508,8 @@ static int e1000_get_eeprom(struct net_device *netdev,
>
>        if (ret_val) {
>                /* a read error occurred, throw away the result */
> -               memset(eeprom_buff, 0xff, sizeof(eeprom_buff));
> +               memset(eeprom_buff, 0xff, sizeof(u16) *
> +                               (last_word - first_word + 1));
>        } else {
>                /* Device's eeprom is always little-endian, word addressable */
>                for (i = 0; i < last_word - first_word + 1; i++)
> --

Thanks Roel.  I will add this to my tree for testing and review.

-- 
Cheers,
Jeff
