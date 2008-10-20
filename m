Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYJTMUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYJTMUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYJTMUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:20:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:61079 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYJTMUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x7dWuJpy3VbwcaH8yKIVmzllQB+JIhSA3niq78G5sgCF6Q0DtmMbHVr+Z/Koj1/NQe
         X+NNKLoWVO2acCj5knm1Y301zrcrMRpmh4amcmuWSUMaTYOkUq3VS2BN1guomigRJy/x
         TAKVy6RrOwOoQIuK+pG71G3fA5rkw+prEaG5g=
Message-ID: <68676e00810200520n6d0fb283y2ae83a0048568017@mail.gmail.com>
Date: Mon, 20 Oct 2008 14:20:13 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: SDHCI: timeout during data transfer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081018224650.2edff23c@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923212459.GA13888@dreamland.darkstar.lan>
	 <20081002101754.031d6710@mjolnir.drzeus.cx>
	 <68676e00810030427g63c07643rf637ca894df795b2@mail.gmail.com>
	 <20081012105227.513bb9a8@mjolnir.drzeus.cx>
	 <68676e00810140234o5e85f438l18058c907a7c6260@mail.gmail.com>
	 <68676e00810141413w384882dbg53af93a1b522e0d3@mail.gmail.com>
	 <20081018224650.2edff23c@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 10:46 PM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Tue, 14 Oct 2008 23:13:39 +0200
> "Luca Tettamanti" <kronos.it@gmail.com> wrote:
>>
>> I finally managed to capture a failure with debug enabled, I'm
>> attaching the log.
>
> It seems to be a transfer error at least as it is in a completely
> different area of the card compared to the first mail you sent.
>
>> To recap:
>> - heavy write loads sometimes result in a timeout
>> - reads seem unaffected (I read the card multiple times without errors)
>
> Looking at the dump, the controller seems to be doing the correct
> thing. The timeout mandated by the SD specification is 250 ms, and that
> time has passed if you look at the timestamps. If you look at some
> other writes further down, the card takes around 220 ms for the writes.
> IOW, it would seem that this card is cutting it a bit close and
> sometimes goes over the alloted time.
>
>> - doubling the timeout (as per my first patch) makes the timeout disappear
>
> Since it is the card that's the problem here, not the controller, we'd
> need to fix this in the core. Unfortunately the sdhci hardware is a bit
> inflexible so any change I make will result in a doubling of the
> timeout.
>
> Could you try modifying line 283 of drivers/mmc/core/core.c where it
> says "limit_us = 250000;" to 300000 instead?

300ms seems to be enough.

>> I've tested two other cards that do not show the problem, but they are
>> not "high speed":
>>
>> mmc0: new high speed SD card at address 0002 (troubles)
>> vs:
>> mmc0: new SD card at address e624 (OK)
>
> What's the vendor and model of the failing card?

The card is from S3+, and it's branded "SD Excel" (el-cheapo 4GB card)

Luca
