Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbZEGRVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbZEGRVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbZEGRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:21:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:14185 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZEGRVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l3vZ1OB5gEquItoPB26s6mU9MyHDq8gv5W9wYCKzPKPd/01mr7KRvkhNd3kKJVzcbL
         IMfYMyU5FxR4MigKd750m6HG7TaVXvEAHm9z3CREL6xX18PlOv5PU8uWEnfjDf2YZJCO
         yK2QzVbshbsoonquD1DYW/6+xKDfBhDgOVAyw=
MIME-Version: 1.0
In-Reply-To: <4A02B1CA.3060708@hiramoto.org>
References: <43e72e890905070104u59eebcceu18718a733e388cc9@mail.gmail.com> 
	<4A02B1CA.3060708@hiramoto.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 May 2009 10:20:48 -0700
Message-ID: <43e72e890905071020v26857c52p3abea96be04ef1d9@mail.gmail.com>
Subject: Re: [ath9k-devel] New kernel recommendations for ath9k
To: Karl Hiramoto <karl@hiramoto.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gabor Juhos <juhosg@openwrt.org>, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 3:02 AM, Karl Hiramoto <karl@hiramoto.org> wrote:
> Luis R. Rodriguez wrote:
>>
>> For those not subscribed to the ath9k wiki on wireless.kernel.org [1]
>> (which we recommend you do if you're a user) here's a quick note to
>> let you know our latest kernel recommendations for using ath9k:
>>
>>  *  >= 2.6.27.22
>>  *  >= 2.6.28.10
>>  *  2.6.29
>>
>> If you want 802.11n support or AP support you'll want at least 2.6.29.
>> If you happen to have one of our new 1x1 AR9285 devices (all AR9285
>> devices are 1x1) then you'll need at least 2.6.29. If you want to
>> start using ath9k on APs with AHB you will need at least 2.6.30 (still
>> in RC series).
>>
>> As usual if you happen to be stuck on older kernels for one reason or
>> another you can always use compat-wireless [2] and if that happens to
>> be a little too bleeding edge we have now compat-wireless releases for
>> stable kernel releases, starting as of the 2.6.30-rc series [3].
>>
>>  Luis
>>
>> [1] http://wireless.kernel.org/en/users/Drivers/ath9k
>> [2] http://wireless.kernel.org/en/users/Download
>> [3] http://wireless.kernel.org/en/users/Download/stable
>>
>
> Thanks for the update.  If i want to use multiple AP's with Ath9k it it
> still best to use wireless-testing?  Is multiple AP support in 2.6.30-rc
> series net-next or wireless-next?

Yeah wireless-testing is best for that. I should also mention that if
you want to use AP mode you want to be at least on 2.6.29 (your own
kernel, not the compat-wireless one) if you care about Power Save
buffering on the AP as otherwise even if you use a compat-wireless
with code from > 2.6.29 those frames will be dropped. IIRC its due to
the way we use skb->cb for this and there not being a clean way to
backport this (so we just drop them).

  Luis
