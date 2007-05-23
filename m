Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbXEWT2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbXEWT2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXEWT2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:28:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56324 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbXEWT2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:28:34 -0400
Date: Wed, 23 May 2007 21:28:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] CDROM: replace jiffies busyloop with msleep
Message-ID: <20070523192816.GA16603@elte.hu>
References: <1179829525.12708.118.camel@chaos> <46548ADB.60207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46548ADB.60207@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> The trouble there is that unless you poll the bloody thing like mad 
> too much of the Q subchannels passes below you and you need a huge 
> number of retries to get anything out of it. I noticed when I started 
> adding audio bits that the driver took full seconds to complete some 
> audio requests while the old driver was snappy in that regard. When I 
> replaced our sleeping loop with a busy-wait same as the original the 
> snappyness returned and moreover, reading the TOC from the CD went 
> from something close to a minute to approximately a second. Thought 
> that minute was just because I was dealing with an old junk 1-speed 
> drive...

ouch ...

then i guess the right approach is to not use jiffies but to use a 
calculated number of udelay(10) calls or so.

	Ingo
