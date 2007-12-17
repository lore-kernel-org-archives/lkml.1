Return-Path: <linux-kernel-owner+w=401wt.eu-S935925AbXLQV3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935925AbXLQV3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763278AbXLQV3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:29:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37134 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525AbXLQV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:28:59 -0500
Date: Mon, 17 Dec 2007 22:28:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "David P. Reed" <dpreed@reed.com>
Cc: Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217212827.GB22828@elte.hu>
References: <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu> <4766D035.7090104@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766D035.7090104@reed.com>
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


* David P. Reed <dpreed@reed.com> wrote:

> Ingo -
>
> I finished testing the rolled up patch that you provided.  It seems to work 
> just fine.  Thank you for putting this all together and persevering in this 
> long and complex discussion. 
> Here are the results, on the offending laptop, using 2.6.24-rc5 plus that 
> one patch.
>
> First: booted with normal boot parameters (no io_delay=):
>
>    According to dmesg, 0xed is used.
>
>    hwclock ran fine, hundreds of times.
>    my shell script loop doing "cat /dev/nvram > /dev/null" ran fine, 
> several times.
>    Running Rene's "port 80" speed test ran fine once, then froze the system 
> hard.  (expected)
>
> Second: booted with io_delay=0x80, several tests, rebooting after freezes:
>
>    hwclock froze system hard.  (this is the problem that drove me to find 
> this bug).
>    my shell script loop froze system hard.
>
> Third: booted with io_delay=none:
>
>    hwclock ran fine, also hundreds of times.
>    my shell script loop ran fine several times.
>    Running rene's port80 test ran fine twice, froze system hard on third 
> try.
>
> Fourth: booted with io_delay=udelay:
>
>    hwclock ran fine, also hundreds of times.
>    my shell script loop ran fine several times.
>    Running Rene's port80 test ran fine, froze system hard on second try.
>
> Analysis:
>
>    patch works fine, and default to 0xed seems super conservative. I 
> will probably use the boot parameter io_delay=none, because I don't 
> seem to have any I/O
>    devices that require any delays - and this way I can find any that 
>    do.

great, and thanks for the extensive testing! I've added this line to the 
patch:

 Tested-by: "David P. Reed" <dpreed@reed.com>

if you dont mind.

	Ingo
