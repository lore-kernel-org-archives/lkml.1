Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbZE1IlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbZE1IlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZE1Iko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:40:44 -0400
Received: from gate1.ipvision.dk ([94.127.49.2]:48399 "EHLO gate1.ipvision.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZE1Ikn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:40:43 -0400
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
From: Benny Amorsen <benny+usenet@amorsen.dk>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Francois Romieu <romieu@fr.zoreil.com>, David Dillow <dave@thedillows.org>,
       linux-kernel@vger.kernel.org, Edward Hsu <edward_hsu@realtek.com.tw>
In-Reply-To: <200905280009.n4S094jJ032395@turbo.physics.adelaide.edu.au>
References: <200905280009.n4S094jJ032395@turbo.physics.adelaide.edu.au>
Content-Type: text/plain
Date: Thu, 28 May 2009 10:40:34 +0200
Message-Id: <1243500034.25386.5.camel@ursa.amorsen.dk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.8 (---)
X-Spam-Report: ALL_TRUSTED=-3.3, AWL=-0.457
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tor, 28 05 2009 kl. 09:39 +0930, skrev Jonathan Woithe:

> I'm not surprised one way or the other since I have no idea what to expect
> when doing these tests on this card with the patches applied.  Given that
> ethtool has a "duplex" option I naively thought that it controlled the
> card's duplex setting.

It does. The card is set to full duplex when you force full duplex.

> I interprete your comment to mean that duplex can't
> be controlled like this and it requires autonegotiation in order to active
> full duplex mode.  If that's the case then so be it - I'm only reporting
> what I did and what effect it had on the card.

No, you're reporting which effect it had on the SWITCH. The switch
detected that autonegotiation failed, so it picked half duplex mode.
Card full duplex, switch half duplex, recipe for disaster.

> FYI, turning off autonegotiation was the only way I had of forcing the
> card's speed.  If autoneg was left on the "speed 10" and "speed 100" options
> made no difference - the card would always configure for 1000 Mbps.

Correct. If you want to influence autonegotiation, you need to do
something like:

ethtool -s eth1 advertise 0x00F

This allows 10Mbps and 100Mbps with half or full duplex, but nothing
faster.

> Furthermore, in order to attain 1000 Mbps it was necessary to turn autoneg
> on - with it off, "speed 1000" would result in 100 Mbps only.  However, I
> seem to recall reading somewhere that 1000 Mbps required autoneg so I'm not
> all that surprised with that observation.

That is correct.

I can recommend man ethtool.


/Benny

