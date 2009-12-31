Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZLaA44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZLaA44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 19:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZLaA4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 19:56:55 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:43372 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZLaA4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 19:56:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cXPyB/xVCUj8AKaQLwVybBQGXJ9JDEIItVgYWJxGAaJsB0F677YvdwN+TBNui1qCEV
         gZNXnUqjAlQVbT65Lh3/nM8xg/ghok2C86cH9YRGjxDcQ8Bq2rJtWOxS4sjtSpfuoEfx
         6Gm8rVIts+Rlp5ofDRZ2tVWbITotQFfqLFphI=
Message-ID: <4B3BF6D1.6010209@googlemail.com>
Date: Thu, 31 Dec 2009 01:56:49 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: wireless tree build warnings
References: <20091231105709.c50f22c0.sfr@canb.auug.org.au>
In-Reply-To: <20091231105709.c50f22c0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/09 00:57, Stephen Rothwell wrote:
> Hi John,
>
> Today's linux-next build (i386 defconfig) produced thes warnings:
>
> net/mac80211/work.c: In function 'ieee80211_remain_on_channel_timeout':
> net/mac80211/work.c:534: warning: cast from pointer to integer of different size
> net/mac80211/work.c: In function 'ieee80211_remain_done':
> net/mac80211/work.c:1030: warning: cast from pointer to integer of different size
> net/mac80211/work.c: In function 'ieee80211_wk_remain_on_channel':
> net/mac80211/work.c:1056: warning: cast from pointer to integer of different size
> net/mac80211/work.c: In function 'ieee80211_wk_cancel_remain_on_channel':
> net/mac80211/work.c:1072: warning: cast from pointer to integer of different size
>
> Introduced by commits e4da8c37af626001ff704fb29ea14eb58f5f7208
> ("mac80211: make off-channel work generic") and
> b8bc4b0aa9bfba755c64b11b8f60e6cfab25dc9d ("mac80211: support
> remain-on-channel command").
>

Hi,
shouldn't it be u32 instead of u64? Please correct me if I'am wrong.

Example:
cfg80211_ready_on_channel(wk->sdata->dev, (u32)wk, wk->chan,
		wk->chan_type, wk->remain.duration, GFP_KERNEL);
instead of:
cfg80211_ready_on_channel(wk->sdata->dev, (u64)wk, wk->chan,
		wk->chan_type, wk->remain.duration, GFP_KERNEL);

I wish you all a happy new year!
