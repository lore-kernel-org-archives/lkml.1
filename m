Return-Path: <linux-kernel-owner+w=401wt.eu-S1765555AbXLPJlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765555AbXLPJlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 04:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbXLPJkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 04:40:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39910 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587AbXLPJkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 04:40:51 -0500
Date: Sun, 16 Dec 2007 10:40:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071216094029.GD27280@elte.hu>
References: <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <20071215230036.GF2434@elf.ucw.cz> <47645D66.4020506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47645D66.4020506@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Pavel Machek wrote:
>>>
>>> this is also something for v2.6.24 merging.
>>
>> As much as I like this patch, I do not think it is suitable for
>> .24. Too risky, I'd say.
>>
>
> No kidding!  We're talking about removing a hack that has been 
> successful on thousands of pieces of hardware over 15 years because it 
                                                             ^----[*]
> breaks ONE machine.

[*] "- none of which needs it anymore -"

there, fixed it for you ;-)

So lets keep this in perspective: this is a hack that only helps on a 
very low number of systems. (the PIT of one PII era chipset is known to 
be affected)

unfortunately this hack's side-effects are mis-used by an unknown number 
of drivers to mask PCI posting bugs. We want to figure out those bugs 
(safely and carefully) and we want to remove this hack from modern 
machines that dont need it. Doing anything else would be superstition.

anyway, we likely wont be doing anything about this in .24.

	Ingo
