Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYGQKDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYGQKDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 06:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbYGQKD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 06:03:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbYGQKD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:03:28 -0400
Date: Thu, 17 Jul 2008 11:59:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, john stultz <johnstul@us.ibm.com>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [crash, bisected] I2C,  kobject (ffff81003e8c4160): tried to
	init an initialized object
Message-ID: <20080717095944.GA2097@elte.hu>
References: <20080714224945.629446fa@hyperion.delvare> <20080716082352.GA30483@elte.hu> <20080716110702.3ca61eb2@hyperion.delvare> <20080716120801.3e9b4c80@hyperion.delvare> <20080716141826.1d88d05e@hyperion.delvare> <20080717092655.GA6115@elte.hu> <20080717093329.GA20032@elte.hu> <20080717094858.GA18687@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717094858.GA18687@martell.zuzino.mipt.ru>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Thu, Jul 17, 2008 at 11:33:30AM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Jean,
> > > 
> > > -tip testing found another (similar) i2c crash with latest -git, on a 
> > > Core2Duo laptop:
> > > 
> > > calling  nforce2_init+0x0/0x1b
> > > initcall nforce2_init+0x0/0x1b returned 0 after 0 msecs
> > > calling  nforce2_s4985_init+0x0/0x275
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000c
> > > IP: [<c04af2cf>] i2c_smbus_xfer+0x27/0x3f0
> > > *pdpt = 00000000009cb001 *pde = 0000000000000000 
> > > Oops: 0000 [#1] SMP 
> > 
> > turning off I2C_NFORCE2_S4985 makes the system boot up fine. Workaround 
> > patch below.
> 
> Well, it's pretty easy oops unless I misread something.
> It happened on not nforce2 motherboard, right?

yeah.

> nforce2_init will just register PCI driver,
> no matching PCI ids => nforce2_set_reference() isn't called =>
> nforce2_smbus stays NULL.
> 
> Second module loads and tries to i2c_smbus_xfer(NULL, ) in module_init()
> hook which oopses.

can try patches, but got other 5 fresh upstream oopses/hangs/crashes to 
investigate now. (so i went for the minimal-effort 
turn-off-the-failing-part approach)

	Ingo
