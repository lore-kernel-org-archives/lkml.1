Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbXL3WCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbXL3WCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758785AbXL3WC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:02:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734AbXL3WCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:02:25 -0500
Date: Sun, 30 Dec 2007 22:54:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230215435.GA31386@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org> <20071230203417.GA12949@elte.hu> <20071230212820.0d53f389@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230212820.0d53f389@the-village.bc.nu>
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

> You won't bisect obscure timing triggered problems, and the _p users 
> are almost all for hardware where performance doesn't matter one iota 
> (eg CMOS).

actually, people have, and i have too. But i agree that io_delay=none 
would be stupid now, and would probably be stupid in v2.6.26 too.

i also have a debug patch that counts the number of _p() API uses and 
prints a stacktrace (once per bootup) if it occurs [wrote it 2 weeks 
ago] - so i agree with you that we can do this more gradually and more 
intelligently. As long as it does not turn into a BKL situation. It's 
2008 in a day and we've still got the NFS client code running under the 
BKL - quite ridiculous IMO.

	Ingo
