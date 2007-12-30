Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbXL3QI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbXL3QI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXL3QIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:08:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579AbXL3QIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:08:20 -0500
Date: Sun, 30 Dec 2007 17:07:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230160751.GB26221@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4777BDA5.4050203@keyaccess.nl>
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

> On 30-12-07 16:28, Ingo Molnar wrote:
>
>> Reading from the 0x3cc port does not impact the cursor position update 
>> sequence IIRC - i think the vidport is even ignored for the input 
>> direction by most hardware, there's a separate input register. The 0x3cc 
>> port is a well-defined VGA register which should be unused on non-VGA 
>> hardware. (which makes it a perfect delay register in any case)
>
> Hardly. Duron 1300 on AMD756:

but that does not matter at all: that's not '90s era hardware that we 
are (slightly) worried about wrt. IO delays in misc_32.c. (i.e. on 
_real_ ISA systems)

> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2401
> rene@7ixe4:~/src/port80$ su -c ./port3cc
> cycles: out 459, in 394

of course, since VGA is implemented in the southbridge or on the video 
card, so it's much faster than a true ISA cycle.

the only (minor) worry we have here is really ancient systems relying on 
delays there. Modern VGA hardware most definitely does not need any such 
delays.

	Ingo
