Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbYBOWzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbYBOWzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763471AbYBOWkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:40:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:47736 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763318AbYBOWkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:40:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OQQsEtS2ajoJqL/hLZspPuCbMXjfHMdQq+MoXCMZUre5yeGLJosGdOpCBhaE1ecKS9Zjdqrc1qjYJJkCIkYl4xchMGCEr54ALaC7xMgFvwl+bp0Iqgu73uOiou0M7p/uRwzmMtKQrzCM61mrkoVBKyBgIvzbADdWcpYwFw7SR3M=
Message-ID: <47B614DE.1050305@gmail.com>
Date: Fri, 15 Feb 2008 23:40:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/1] WDEV: ath5k, test single chip before reset
References: <1203107827-27632-1-git-send-email-jirislaby@gmail.com> <40f31dec0802151353l2d03fdaam23d4f731a6c7bddc@mail.gmail.com>
In-Reply-To: <40f31dec0802151353l2d03fdaam23d4f731a6c7bddc@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2008 10:53 PM, Nick Kossifidis wrote:
> 2008/2/15, Jiri Slaby <jirislaby@gmail.com>:
>> Move ath5k_hw_nic_wakeup after ah_single_chip being set, because we
>>  test the value in there and decides whether reset or not.
>>
>>  Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>  Cc: Nick Kossifidis <mickflemm@gmail.com>
>>  Cc: Luis R. Rodriguez <mcgrof@gmail.com>
>>  ---
>>   drivers/net/wireless/ath5k/hw.c |   21 ++++++++++-----------
>>   1 files changed, 10 insertions(+), 11 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>>  index 3a4bf40..9cdd27f 100644
>>  --- a/drivers/net/wireless/ath5k/hw.c
>>  +++ b/drivers/net/wireless/ath5k/hw.c
[...]
>>  @@ -210,12 +205,13 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>>         }
>>
>>         /* Identify single chip solutions */
>>  -       if((srev <= AR5K_SREV_VER_AR5414) &&
>>  -       (srev >= AR5K_SREV_VER_AR2424)) {
>>  -               ah->ah_single_chip = true;
>>  -       } else {
>>  -               ah->ah_single_chip = false;
>>  -       }
>>  +       ah->ah_single_chip = srev >= AR5K_SREV_VER_AR2424 &&
>>  +                       srev <= AR5K_SREV_VER_AR5414;
>>  +
>>  +       /* Bring device out of sleep and reset it's units */
>>  +       ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
>>  +       if (ret)
>>  +               goto err_free;
>>
>>         /* Single chip radio */
>>         if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
>>
> 
> NACK, single chip flag is going out since only needed check is for
> 5424/2424 during nic_wakeup, 5413/2413 behave like the rest
> 5211/5212-combatible cards.

Ok, thanks.

> Sorry for delaying the relevant patches, i'm working with the 2413
> card i got from Mike to make it work and it'll take some time (not as
> easy as i thought, i probably miss something)...

No problem, if I could do anything for you in this area, don't hesitate to drop 
a message.
