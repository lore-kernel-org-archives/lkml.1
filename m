Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbXL3Vd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbXL3Vd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbXL3VdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:33:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33855 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026AbXL3VdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:33:21 -0500
Date: Sun, 30 Dec 2007 22:25:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230212536.GA5370@elte.hu>
References: <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <20071230160751.GB26221@elte.hu> <4777C6E8.7060202@keyaccess.nl> <20071230170612.GA16502@elte.hu> <20071230182937.40f2adcf@the-village.bc.nu> <20071230204650.GA26120@elte.hu> <47780888.9070503@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47780888.9070503@keyaccess.nl>
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


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 30-12-07 21:46, Ingo Molnar wrote:
>> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>
>>>> So the current plan is to go with an io_delay=udelay default in v2.6.25, 
>>>> to give this a migration window, and io_delay=none in v2.6.26 [and a 
>>>> complete removal of arch/x86/kernel/io_delay.c], once the _p() uses are 
>>>> fixed up. This is gradual enough to notice any regressions we care about 
>>>> and also makes it nicely bisectable and gradual.
>>> You will break systems if you blindly go around disabling _p delays for 
>>> ISA and LPC bus devices. The DEC Hinote laptops for example are well 
>>> known for requiring the correct ISA and other keyboard controller delays. 
>>> I don't expect anyone to test with a hinote or see it until it hits 
>>> Debian or similar 'low resource' friendly devices.
>>
>> well, using io_delay=udelay is not 'blindly disabling'.
>
> On the other hand, the patch you just posted that makes io_delay=none 
> the default _is_ blindly disabling. So that wasn't for consumption?

if you want to see the current x86.git intention then do:

 git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
 cd linux-2.6.git
 git-branch x86
 git-checkout x86
 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

right now the default is io_delay=udelay.

	Ingo
