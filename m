Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbZDLQfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbZDLQfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZDLQez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:34:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55101 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZDLQey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:34:54 -0400
Date: Sun, 12 Apr 2009 18:33:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090412163356.GA2392@elte.hu>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Sure, go ahead and wrap them in some kind of "save and restore all 
> registers" wrapping, but nothing fancier than that. It would just 
> be overkill, and likely to break more than it fixes.

Yeah. I only brought up the virtualization thing as a hypothetical: 
"if" corrupting the main OS ever became a widespread problem. Then i 
made the argument that this is unlikely to happen, because Windows 
will be affected by it just as much. (while register state 
corruptions might go unnoticed much more easily, just via the random 
call-environment clobbering of registers by Windows itself.)

The only case where i could see virtualization to be useful is the 
low memory RAM corruption pattern that some people have observed. 

The problem with it, it happens on s2ram transitions, and that is 
driven by SMM mainly - which is a hypervisor sitting on top of all 
the other would-be-hypervisors and thus not virtualizable.

Which leaves us without a single practical case. So it's not going 
to happen.

	Ingo
