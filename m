Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYJ0WlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYJ0WlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYJ0Wk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:40:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9539 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0Wk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PPsaWeGW70SsHJN+s19KFXWtZMeRQMwdMq9eoyXgwUf4xF2D6uAAtm3ib31BR/VTq5
         sd5k540wR0mZ9zP0BNyoSDR1Jl0u5pxpC/Nu6Q6ZMJ2GeGrCJW/jTJEpJxhGykytlvQn
         BfcQMyTJeznn7Yl9/o8snwVlxPNkQJGKrVvAc=
Message-ID: <1ba2fa240810271540t1d1ba5c9me60f86dec357f53e@mail.gmail.com>
Date: Tue, 28 Oct 2008 00:40:55 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Soeren Sonnenburg" <kernel@nn7.de>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20081027222852.GA3907@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <1225134823.3796.45.camel@johannes.berg>
	 <20081027203925.GA4416@localhost.aei.mpg.de>
	 <200810272151.01244.rjw@sisk.pl>
	 <1ba2fa240810271407o15f1f150t2d2793f4e5ad6e5b@mail.gmail.com>
	 <20081027222852.GA3907@localhost.aei.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 12:28 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> On Mon 27.Oct'08 at 23:07:00 +0200, Tomas Winkler wrote:
>>[...]
>>
>> Can someone try this one (it might be space broken I've just pasted
>> that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
>> (latest linux-2.6.git)
>
>
> Yes, this one also works for me (I applied it manually).
Good, this was actually part of some older and bigger patch I wasn't
aware it has this affect. It has some millage in iwl5000 branch.
RFKIll went through some changes in the mainline so it wasn't merged yet.

commit a91ad840c23a70bc0eabe239e178e0d979a6d44e
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Mon Jun 30 17:48:26 2008 +0300
iwlwifi: bug fixes in RF-kill flows

Tomas
>
>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
>> b/drivers/net/wireless/iwlwifi/iwl-agn.c
>> index 24a1aeb..321dbc8 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
>> @@ -2090,7 +2090,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
>>                 iwl4965_error_recovery(priv);
>>
>>         iwl_power_update_mode(priv, 1);
>> -       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
>>
>>         if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
>>                 iwl4965_set_mode(priv, priv->iw_mode);
>> @@ -2342,6 +2341,7 @@ static void iwl_bg_alive_start(struct work_struct *data)
>>         mutex_lock(&priv->mutex);
>>         iwl_alive_start(priv);
>>         mutex_unlock(&priv->mutex);
>> +       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
>>  }
>>
>>  static void iwl4965_bg_rf_kill(struct work_struct *work)
>>
>>
>> Thanks
>> Tomas
>
