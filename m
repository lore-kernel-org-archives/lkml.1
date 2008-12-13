Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbYLMOhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbYLMOhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbYLMOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:37:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:5027 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYLMOhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:37:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gVU3rpi42ciNbNkHfvpSXkRR1GFEaA1WswZMxktT4bcHpEE1Z4fsE4cJZAAOjh37Es
         cqYynR15cD0PPCZiyRXml5EKYKitifURuSoS5RUQjWG+O6Hsm7TbAzOfJFQMc5s9SBY6
         8xNMRB8n6CaufnJyQuoZruWZ0sc8HLwlroOm8=
Subject: Re: [ath5k-devel] Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <40f31dec0812130608x73266375n7b3367938ad687b8@mail.gmail.com>
References: <491506DB.1070000@gmail.com>
	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
	 <4918A8C5.3050607@gmail.com>
	 <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
	 <1229174904.4964.5.camel@maxim-laptop>
	 <40f31dec0812130608x73266375n7b3367938ad687b8@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 16:36:53 +0200
Message-Id: <1229179013.4936.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 16:08 +0200, Nick Kossifidis wrote:
> 2008/12/13 Maxim Levitsky <maximlevitsky@gmail.com>:
> >
> > Hi,
> >
> > Indeed gpio #3 controls the led.
> > I patched ath5k to use it, and led works now fine.
> >
> >
> 
> Please share your patch with the rest and also post an lspci -vnn for
> your card so we can handle this in a generic way

This just a one liner hack

diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index 9d2c597..a447937 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2595,6 +2595,11 @@ ath5k_init_leds(struct ath5k_softc *sc)
 		sc->led_pin = 1;
 		sc->led_on = 1;  /* active high */
 	}
+
+	__set_bit(ATH_STAT_LEDSOFT, sc->status);
+	sc->led_pin = 3;
+	sc->led_on = 1;
+
 	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
 		goto out;




lspci -vnn:

03:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x
802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
	Subsystem: Foxconn International, Inc. Device [105b:e008]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 55200000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: ath5k
	Kernel modules: ath5k


Best regards,
	Maxim Levitsky

