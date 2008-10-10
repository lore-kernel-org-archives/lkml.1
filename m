Return-Path: <linux-kernel-owner+w=401wt.eu-S1763055AbYJJTBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763055AbYJJTBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760620AbYJJTAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:00:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:10733 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760308AbYJJTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=g8txdtKfGPMDfbNxKs+dp0cmzb1KX6w3ga57sb7gLLqM6zEKZAclr2DRl6Pxn0+NsX
         LfgVI6d1JIOGs2nUfb/3y7eN5ILUucnP79S/OhPn1vCZtuc6mvRZYH6oUz7BzckjjZgw
         cwTWS1TLXOk9FnFTUFURZS5KjZy5hkknjvvCI=
Message-ID: <43e72e890810101200g3f50b204t20ea782878217369@mail.gmail.com>
Date: Fri, 10 Oct 2008 12:00:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
Cc: jirislaby@gmail.com, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       jmalinen@atheros.com
In-Reply-To: <20081010.115318.85254002.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
	 <20081010.115318.85254002.davem@davemloft.net>
X-Google-Sender-Auth: a801b78f0462557a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 11:53 AM, David Miller <davem@davemloft.net> wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Fri, 10 Oct 2008 19:56:43 +0200
>
>> status ath9k_hw_reset() parameter should be set in every case, since
>> it is used in callers to find out an error code.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
>> Cc: Jouni Malinen <jmalinen@atheros.com>
>> ---
>>  drivers/net/wireless/ath9k/hw.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
>> index 62e44a0..fb6727b 100644
>> --- a/drivers/net/wireless/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath9k/hw.c
>> @@ -5893,7 +5893,7 @@ bool ath9k_hw_reset(struct ath_hal *ah,
>>       }
>>
>>       if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
>> -             return false;
>> +             FAIL(-EIO);
>>
>
> This fix may be correct, but this is the first time I've noticed
> these error status updating macros and they are super ugly.
>
> I really think they should be removed.  Someone casually scanning
> this code won't be able to discern the side effects and that makes
> auditing harder and more error prone.

Agreed, patches welcomed.

  Luis
