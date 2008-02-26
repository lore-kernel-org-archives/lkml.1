Return-Path: <linux-kernel-owner+w=401wt.eu-S1765301AbYBZWsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765301AbYBZWsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759776AbYBZWr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:47:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:4683 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696AbYBZWr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:47:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sr4lU7CBjRrXTm6YoWrod6rm0d5SCAl0KVDDUS7zn0KL8TlP7UkUxwSZ/59KFzl9aaYcH5KxUmXA+8YJagMUEW+Z3e2JSce6DH7xB/z9baRfHSFeGBuTGBEJHUOye+UhTNVcmb/60sh9U3D7aNaAp1s7TRR9gnM3U5csWWO7P58=
Message-ID: <1ba2fa240802261447udd3ff92t20aba416362d5e33@mail.gmail.com>
Date: Wed, 27 Feb 2008 00:47:56 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct use of ! and &
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:44 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
>  In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
>  involved converting !x & y to !(x & y).  The code below shows the same
>  pattern, and thus should perhaps be fixed in the same way.
>
>  This is not tested and clearly changes the semantics, so it is only
>  something to consider.
>
>  The semantic patch that makes this change is as follows:
>  (http://www.emn.fr/x-info/coccinelle/)
>
>  // <smpl>
>  @@ expression E1,E2; @@
>  (
>   !E1 & !E2
>  |
>  - !E1 & E2
>  + !(E1 & E2)
>  )
>  // </smpl>
>
>  Signed-off-by: Julia Lawall <julia@diku.dk>
>
>  ---
>
>  diff -u -p a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
>  --- a/drivers/net/wireless/iwlwifi/iwl-4965.c 2008-02-05 20:56:01.000000000 +0100
>  +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c 2008-02-26 08:09:12.000000000 +0100
>  @@ -4589,7 +4589,7 @@ static u8 iwl4965_is_fat_tx_allowed(stru
>
>         if (sta_ht_inf) {
>                 if ((!sta_ht_inf->ht_supported) ||
>  -                  (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
>  +                  (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
>                         return 0;
>         }

The patch was already submitted by Roel Kluin '[PATCH]
[wireless/iwlwifi/iwl-4965.c] add parentheses' I've acked it.
Didn't track it if it's actually committed into tree... John, Reinette ?

Thanks
Tomas


>  -
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
