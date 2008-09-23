Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYIWQVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYIWQVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYIWQU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:20:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:52717 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYIWQU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:20:58 -0400
Message-ID: <f488382f0809230920m7c42c557m85fda9381fea707e@mail.gmail.com>
Date: Tue, 23 Sep 2008 09:20:55 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0809230055m498d411fn59a5fbb1c6b2e970@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Disposition: inline
References: <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com>
	 <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com>
	 <20080922065453.GD19580@tesla>
	 <f488382f0809220026u9afa355g1ff2cc7a3fe88333@mail.gmail.com>
	 <20080922080632.GA20446@tesla>
	 <f488382f0809220811y46e9daf3r5db5a7c76df87800@mail.gmail.com>
	 <43e72e890809220901y162636fu63ed133f0a0c235@mail.gmail.com>
	 <f488382f0809230022v582df76esa8df8c747ab600df@mail.gmail.com>
	 <f488382f0809230055m498d411fn59a5fbb1c6b2e970@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m8NGLKdq032437

2008/9/23 Steven Noonan <steven@uplinklabs.net>:> 2008/9/23 Steven Noonan <steven@uplinklabs.net>:>> On Mon, Sep 22, 2008 at 9:01 AM, Luis R. Rodriguez>> <lrodriguez@atheros.com> wrote:>>> On Mon, Sep 22, 2008 at 8:11 AM, Steven Noonan <steven@uplinklabs.net> wrote:>>>> On Mon, Sep 22, 2008 at 1:06 AM, Luis R. Rodriguez>>>> <lrodriguez@atheros.com> wrote:>>>>> Please test the following patch.>>>>>>>>>> diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c>>>>> index c262ef2..9a51739 100644>>>>> --- a/drivers/net/wireless/ath9k/core.c>>>>> +++ b/drivers/net/wireless/ath9k/core.c>>>>> @@ -681,10 +681,12 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)>>>>>         * Enable MIB interrupts when there are hardware phy counters.>>>>>         * Note we only do this (at the moment) for station mode.>>>>>         */>>>>> +#if 0>>>>>        if (ath9k_hw_phycounters(ah) &&>>>>>            ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||>>>>>             (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))>>>>>                sc->sc_imask |= ATH9K_INT_MIB;>>>>> +#endif>>>>>        /*>>>>>         * Some hardware processes the TIM IE and fires an>>>>>         * interrupt when the TIM bit is set.  For hardware>>>>>>>>>>>>> It didn't apply to -rc7, but I managed to apply it manually>>>> (apparently you made this for wireless-testing?) and added the #if 0.>>>> After 7 hours uptime with the driver, no apparent interrupt storm.>>>>>>>> I'll do more thorough testing later, but I have a 3 hour drive today,>>>> and some packing to do, so it'll need to wait a bit.>>>>>> Yeah I did it for wireless-testing. Good to hear this so far has>>> solved the issue. I'll port it to 27 and post it once I get your>>> blessings that this fixed it by a Tested-by.>>>>>>> Okay. I'm in Seattle now.>>>> Yes, it solved the issue, but surely an #if 0 isn't a proper solution.>> What's the actual bug here? I'm afraid the meaning of what's going on>> here isn't exactly intuitive.>>>> Also, I'm doing an 8 hour run with this patch tonight. Maybe more,>> depends on when I wake up. ;)>>>> I think if this resolves the issue on two separate —8 hour runs, it>> should be considered the solution to the issue, unless it resurfaces.>>>> I am only 25 minutes into the run, but I feel this is worth reporting> before I forget. No IRQ storm thus far, but the connection keeps> dropping. Or rather, it doesn't disassociate, but while I was> transferring a large file, it had points of time where it suddenly> lost and reacquired the connection (signal strength fluctuates wildly> between 70-90% and then 0% for a second, and then back to> fluctuating). Perhaps this is related to the lack of aggregation?>
This 8 hour test passes.
- Stevenÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
