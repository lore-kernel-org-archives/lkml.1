Return-Path: <linux-kernel-owner+w=401wt.eu-S1030593AbXB0Ip7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030593AbXB0Ip7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161037AbXB0Ip6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:45:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52364 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030603AbXB0Ipi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:45:38 -0500
Date: Tue, 27 Feb 2007 09:39:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>
Subject: regression: forcedeth.c hang
Message-ID: <20070227083918.GC30376@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175247.GB12392@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225175247.GB12392@stusta.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.1.7
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4080]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> This email lists some known regressions in 2.6.21-rc1 compared to 
> 2.6.20 that are not yet fixed in Linus' tree.

just found a new one: forcedeth.c broke since v2.6.20. It generates a 
few irqs after ifup and then stops dead (no in/out packets). Undoing all 
of these commits fixes the problem:

 commit 21828163b2b31e0675cb3e66a2a4a231dec06236
 commit 57fff6986b6daae13947c565786757c05303f0f6
 commit 4e16ed1b0e17a3832310031e2ddaeb0914eb837d
 commit f0734ab658390380079369f7090dcf7aa226f394
 commit b01867cbd1853995946c8c838eff93a0885d8bc6
 commit 445583b89d71b48cf8c64e26acc5a710248feed7
 commit aaa37d2d099f97ced415546e285ac901e47a2437
 commit 86b22b0dfbf462e6ed75e54fc83575dae01e3c69
 commit 0d63fb32b2b8c3464d9c1afc3ce3fd3ceec025b6
 commit 164a86e40e6c74ec5a91c364ccf7b1a2295b0a52
 commit 761fcd9e3e0aa2a02231d1631f31409be5e890d2
 commit d2f7841277d8613a780ab28d04d8f31a31816153
 commit 1d39ed565cfcc7c4fe586de621aef495c4f94ffb

that's 75K of delta - i'll bisect it some more. Hardware in question:

 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)

config options:

 CONFIG_FORCEDETH=y
 CONFIG_FORCEDETH_NAPI=y

	Ingo
