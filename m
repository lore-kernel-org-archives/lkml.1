Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbZABT6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbZABT6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbZABT6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:58:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbZABT6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:58:22 -0500
Date: Fri, 2 Jan 2009 20:58:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: tip - Solution of ath9k: turn off temporarily
	(66b5c4a2c638b5a69d3e41abe4a2bae55035a92e)
Message-ID: <20090102195802.GA28494@elte.hu>
References: <3f9a31f40901020936l4bed87e2jb64678572d2ad45b@mail.gmail.com> <20090102180730.GA10072@elte.hu> <3f9a31f40901021040l2afb5e19sc37e61d3f9728531@mail.gmail.com> <495E6C96.3040102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495E6C96.3040102@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@kernel.org> wrote:

> Jaswinder Singh Rajput wrote:
> >>
> >> diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath9k/Kconfig
> >> index c43bd32..b849a45 100644
> >> --- a/drivers/net/wireless/ath9k/Kconfig
> >> +++ b/drivers/net/wireless/ath9k/Kconfig
> >> @@ -1,6 +1,8 @@
> >>  config ATH9K
> >>        tristate "Atheros 802.11n wireless cards support"
> >>        depends on PCI && MAC80211 && WLAN_80211
> >> +       # build failures
> >> +       depends on 0
> >>        select MAC80211_LEDS
> >>        select LEDS_CLASS
> >>        select NEW_LEDS
> >>
> > 
> 
> I thought the proper way to do this was "depends on BROKEN"...

this was just a temporary hack to work around a mild regression in -git 
that i'm sure will be sorted out in short order (if it has not been 
already).

CONFIG_BROKEN is a much different category: it blacklists ridiculously 
stale or mortally broken features/drivers, as a last warning before they 
get removed for good. I dont use it in such temporary, not-for-upstream 
testing hacks (even though the end result is obviously the same as 
'depends on 0') - i didnt even have time to properly report the build 
breakage.

	Ingo
