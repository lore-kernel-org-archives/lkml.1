Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZABSIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZABSIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbZABSH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:07:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59605 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851AbZABSHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:07:55 -0500
Date: Fri, 2 Jan 2009 19:07:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net
Subject: Re: tip - Solution of ath9k: turn off temporarily
	(66b5c4a2c638b5a69d3e41abe4a2bae55035a92e)
Message-ID: <20090102180730.GA10072@elte.hu>
References: <3f9a31f40901020936l4bed87e2jb64678572d2ad45b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901020936l4bed87e2jb64678572d2ad45b@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> Hello Ingo,
> 
> If you choose :
> CONFIG_RFKILL=m
> CONFIG_ATH9K=y
> 
> It will give linking error because ATH9K need RFKILL functions.
> 
> But if you choose :
>  CONFIG_RFKILL=y
>  CONFIG_ATH9K=y
> 
> OR
> 
>  CONFIG_RFKILL=m
>  CONFIG_ATH9K=m
> 
> It is OK.

this was just a quick hatchet job to make the build regression go away. 
Would you like to send a real fix, with the wireless list and maintainers 
Cc-ed? Then i can revert the hack below from tip/out-of-tree.

	ngo

------------------>
>From 66b5c4a2c638b5a69d3e41abe4a2bae55035a92e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 2 Jan 2009 16:04:03 +0100
Subject: [PATCH] ath9k: turn off temporarily

Impact: fix build failure

ath9k fails to build:

 drivers/built-in.o: In function `ath_detach':
 main.c:(.text+0x16720b): undefined reference to `rfkill_unregister'
 drivers/built-in.o: In function `ath_rfkill_poll':
 main.c:(.text+0x167801): undefined reference to `rfkill_force_state'
 drivers/built-in.o: In function `ath9k_start':
 main.c:(.text+0x167f01): undefined reference to `rfkill_register'
 main.c:(.text+0x167f11): undefined reference to `rfkill_free'
 drivers/built-in.o: In function `ath_pci_probe':
 main.c:(.text+0x169754): undefined reference to `rfkill_allocate'

when:

 CONFIG_RFKILL=m
 CONFIG_ATH9K=y
---
 drivers/net/wireless/ath9k/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath9k/Kconfig
index c43bd32..b849a45 100644
--- a/drivers/net/wireless/ath9k/Kconfig
+++ b/drivers/net/wireless/ath9k/Kconfig
@@ -1,6 +1,8 @@
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
+	# build failures
+	depends on 0
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
