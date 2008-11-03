Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYKCO0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYKCO0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYKCO00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:26:26 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:55791 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYKCO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:26:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IqhawHDQMSU9g7LXHRTp9LnfRAhmlVpRm/HVIzOheUcgR9OurDoYw816Nj1PBCMd5r
         gdDdAEXvFJUVV4MPOFLt1gU9nOMzgeYqlqMicxXL2QptMI0wCcmR2Usd+jyS/K9gQ0Ae
         PWNLuXmbau1KV/59OZv+1J4LkZcCLTL/QqoNo=
Message-ID: <b6c5339f0811030626rf9e7147peb1d4a2ca085bba@mail.gmail.com>
Date: Mon, 3 Nov 2008 09:26:24 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
Cc: jirislaby@gmail.com, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       michael+ath5k@stapelberg.de, linux-kernel@vger.kernel.org
In-Reply-To: <1225719328.3575.9.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
	 <1225719328.3575.9.camel@dv>
X-Google-Sender-Auth: a2743ae5b0c2fa55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 8:35 AM, Pavel Roskin <proski@gnu.org> wrote:
> Thanks for catching it!  Please mention rs_antenna in addition to
> rs_more.
>
>> -     rs->rs_antenna = rx_status->rx_status_0 &
>> -             AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
>> -     rs->rs_more = rx_status->rx_status_0 &
>> -             AR5K_5210_RX_DESC_STATUS0_MORE;
>> +     rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
>> +             AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA);
>> +     rs->rs_more = AR5K_REG_MS(rx_status->rx_status_0,
>> +             AR5K_5210_RX_DESC_STATUS0_MORE);
>
> rs_more should be boolean.  It would be better to use "!!" to calculate
> rs_rate.  No need to shift anything.  As for rs_antenna, it's fine with
   ^^^^^^
I assume you meant rs_more again:  rs_more = !!(rx_status_0 & ...)

>> +#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR_S 13
>
> This doesn't belong to the patch.  It looks like it's another boolean
> value, but it's not currently used.

ACK, all valid.  I'll respin.

-- 
Bob Copeland %% www.bobcopeland.com
