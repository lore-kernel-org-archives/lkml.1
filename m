Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYJOKEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYJOKEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYJOKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:04:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33243 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYJOKEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:04:11 -0400
Date: Wed, 15 Oct 2008 12:02:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [GIT] HID patches for 2.6.28
Message-ID: <20081015100252.GA26296@elte.hu>
References: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz> <alpine.LNX.1.10.0810150011280.26779@jikos.suse.cz> <20081015093636.GB19403@elte.hu> <alpine.LNX.1.10.0810151139200.26779@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810151139200.26779@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 15 Oct 2008, Ingo Molnar wrote:
> 
> > this or the I2C updates cause widespread build failures in latest -git:
> 
> For the usbhid_set_leds(), Adrian has already sent me a fix [1]. 
> Still, I would like to understand whether this failure is bug or 
> feature in select/depends handling in Kconfig, because it seems to 
> behave differently from what I was expecting.

yes, it's a kconfig bug: Kconfig must either not allow complex selects 
(during its initial parsing pass of the Kconfig dependnecy tree) or 
handle the dependencies correctly.

The current "allow them silently and pepper the kernel with build 
errors" approach is obviously silly.

We already have over 100 bugfixes in the tree from the past 3 years due 
to kconfig's inability to figure out the correct dependencies. (count: 
rising steadily)

Changes to the Kconfig tool to address this design bug did not get 
picked up. See for example this quick patch from Vegard half a year ago:

  http://lkml.org/lkml/2008/5/4/13

that patch was not adopted and the config options in the warning log 
were later on frequent participants in build failures and subsequent 
stream of trivial fixes.

	Ingo
