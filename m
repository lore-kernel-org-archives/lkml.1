Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYAAQud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYAAQud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYAAQu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:50:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYAAQuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:50:25 -0500
Date: Tue, 1 Jan 2008 17:43:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101164338.GA901@elte.hu>
References: <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com> <4765EE7F.80002@zytor.com> <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101161557.3ce2d5f8@the-village.bc.nu>
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

> Ingo - the fact that so many ISA bus devices need _p to mean "ISA bus 
> clocks" says to me we should keep the _p port 0x80 using variant for 
> old systems/device combinations (eg ISA ethernet cards) which won't 
> show up in any problem system (we know this from 15 odd years of 
> testing), but stop using it for PCI and embedded devices on modern 
> systems.

yes, ISA is fragile, and no way do we want to remove the delay, but are 
there strong counter-arguments against doing the clean thing and adding 
an udelay(2) (or udelay(1)) to replace those _p() uses in ISA drivers? 
That removes the global effect once and forever. Initially for 
standalone drivers without early bootup functionality, not platform 
drivers that might need to run before we have calibrated udelay.

if someone runs a fresh new kernel on an ancient device then timings 
_will_ change a bit, no matter what we do. Alignments change, the 
compiler output will change (old compilers get deprecated so a new 
compiler might have to be picked), cache effects change - and this is 
inevitable. The important thing is to not eliminate the delays - but we 
sure dont have to keep them cycle accurate (we couldnt even if we wanted 
to). The only way to get the _exact same_ behavior is to not change the 
kernel at all.

	Ingo
