Return-Path: <linux-kernel-owner+w=401wt.eu-S1765561AbXLON1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561AbXLON1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 08:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXLON1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 08:27:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57808 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbXLON1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 08:27:46 -0500
Date: Sat, 15 Dec 2007 14:27:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071215132725.GA23166@elte.hu>
References: <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071215074358.GD12110@elte.hu> <4763891A.3010004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4763891A.3010004@gmail.com>
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

> The issue is -- how do you safely replace the outb pre-loops_per_jiffy 
> calibration? I'm currently running with the attached hack (not 
> submitted, only for 32-bit and discussion) the idea of which might be 
> the best we can do?

how about doing a known-NOP chipset cycle? For example:

  inb(PIC_SLAVE_IMR)

? I.e. instead of trying to find an unused port, lets try to find a 
known-used platform register that has no side-effects if read. Use it 
unconditionally during early bootup and change it to an udelay after 
calibration. (or use it after early bootup too if a boot parameter has 
been specified) Or something like this.

	Ingo
