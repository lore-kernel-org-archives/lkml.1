Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYGUTfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYGUTfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYGUTem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:34:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37411 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbYGUTek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:34:40 -0400
Date: Mon, 21 Jul 2008 21:34:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ian Schram <ischram@telenet.be>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       wireless <linux-wireless@vger.kernel.org>, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
	at 0000000000000370
Message-ID: <20080721193425.GA29287@elte.hu>
References: <20080721134506.GA27598@elte.hu> <20080721143023.GA32451@elte.hu> <20080721150446.GA17746@elte.hu> <20080721.082419.70392960.davem@davemloft.net> <4884D2F1.2030704@telenet.be> <20080721190646.GA19044@elte.hu> <4884DFEE.4060003@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4884DFEE.4060003@lwfinger.net>
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


* Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Ingo Molnar wrote:
>> * Ian Schram <ischram@telenet.be> wrote:
>>
>>> I was looking at this out of interest, but I'm in no way familiar 
>>> with the code.
>>
>> thanks Ian for the patch, i'll test it.
>>
>> Note that it was whitespace damaged, find below a tidied up version of  
>> the patch that i've applied to tip/out-of-tree.
>>
>> 	Ingo
>
> This patch may be needed to fix error handling in the hw_sim code, but 
> I get the crash even with that code disabled. I'm currently bisecting 
> to find the culprit.

ok. I just reactivated CONFIG_MAC80211_HWSIM, applied Ian's fix and the 
crash went away:

 calling  iwl4965_init+0x0/0x6c
 iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.3.27kd
 iwl4965: Copyright(c) 2003-2008 Intel Corporation
 initcall iwl4965_init+0x0/0x6c returned 0 after 10 msecs
 calling  init_mac80211_hwsim+0x0/0x31c
 mac80211_hwsim: Initializing radio 0
 PM: Adding info for No Bus:hwsim0
 PM: Adding info for No Bus:phy0
 PM: Adding info for No Bus:wmaster0
 phy0: Failed to select rate control algorithm
 phy0: Failed to initialize rate control algorithm
 PM: Removing info for No Bus:wmaster0
 PM: Removing info for No Bus:phy0
 mac80211_hwsim: ieee80211_register_hw failed (-2)
 PM: Removing info for No Bus:hwsim0
 initcall init_mac80211_hwsim+0x0/0x31c returned -2 after 58 msecs
 initcall init_mac80211_hwsim+0x0/0x31c returned with error code -2
 calling  dmfe_init_module+0x0/0xea
 dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
 initcall dmfe_init_module+0x0/0xea returned 0 after 5 msecs

So at least as far as the init_mac80211_hwsim() deinit crash goes:

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
