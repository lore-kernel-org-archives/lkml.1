Return-Path: <linux-kernel-owner+w=401wt.eu-S1764115AbXLQVp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764115AbXLQVp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761433AbXLQVpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:45:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbXLQVpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:45:14 -0500
Date: Mon, 17 Dec 2007 22:41:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217214139.GC22828@elte.hu>
References: <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu> <4766E086.9090500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766E086.9090500@gmail.com>
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


* Rene Herman <rene.herman@gmail.com> wrote:

> On 17-12-07 17:12, Alan Cox wrote:
>
>> I don't think we should be offering udelay based delays at this point.
>> There are a lot of drivers to fix first. This is just one trivial example
>
> I agree. This thread's too full of people calling this outb method a 
> dumb hack. It's a well-known legacy PC thing and while in practice the 
> udelay might be a functional replacement for a majority of cases (save 
> the races you are finding) a delay proportional to the bus speed makes 
> great sense certainly when talking to hardware that itself runs 
> proportinal to the bus speed for example.
>
> So, really, how about just sticking in this minimal version for now? 
> Only switches the port to 0xed based on DMI and is all that is needed 
> to fix the actual problem. This should be minimal and no-risk enough 
> that it could also go to .24 if people want it to. It'll fix a few HP 
> laptops (I'll try and get/verify the dv6000z DMI strings as well).
>
> Ingo?
>
> Signed-off-by: Rene Herman <rene.herman@gmail.com>

hm, i see this as a step backwards from the pretty flexible patch that 
David already tested. (and which also passed a few hundred bootup tests 
on my x86 test-grid)

	Ingo
