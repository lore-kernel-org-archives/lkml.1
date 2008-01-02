Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbYABKFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbYABKFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYABKFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:05:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47462 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbYABKFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:05:06 -0500
Date: Wed, 2 Jan 2008 11:04:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080102100436.GB4389@elte.hu>
References: <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu> <20080101164338.GA901@elte.hu> <20080101173212.1bba4939@the-village.bc.nu> <20080101184524.GA6655@elte.hu> <20080101210734.03414931@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101210734.03414931@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > udelay is supposed to be reliable. If someone runs a new kernel and 
> > has no TSC (which might happen even on modern hardware or with 
> > notsc) _and_ finds that udelay is not calibrated well enough then 
> > that's a kernel bug we want to fix.
> 
> You miss the point entirely. The delay is in bus clocks not CPU 
> clocks, not tsc clocks not PIT clocks, and it is permitted to vary by 
> a factor of two. So you'll worst case halve the speed of network 
> packet up/download even if your udelay is accurate.

ok, you are right. How about we go with one of your suggestions: rename 
the API family to isa_*_p() in the affected ISA drivers? That makes it 
perfectly clear that this is an ISA related historic quirk that we just 
cannot properly emulate in an acceptable fashion. It will also make the 
least amount of changes to these truly historic drivers.

The main maintenance thing we are interested in is to have no subsequent 
new uses of this API and to eliminate these accesses from modern 
hardware - and naming it clearly 'ISA' and making it dependent on 
CONFIG_ISA would likely achieve that purpose.

oh, another thing: there are 100+ mails in this thread while there are 
only 3 mails in the thread that lists 61 not-yet-fixed-in-2.6.24 
regressions:

|  Listed regressions statistics:
|
|  Date          Total  Pending  Unresolved
|  ----------------------------------------
|  Today           139       38          23

which is a sad proportion of attention :-/

	Ingo
