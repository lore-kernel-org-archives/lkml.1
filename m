Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbYHSJf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbYHSJf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYHSJfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:35:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYHSJfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:35:18 -0400
Date: Tue, 19 Aug 2008 11:34:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] i486 CR4 oops, no_console_suspend
Message-ID: <20080819093454.GG28713@elte.hu>
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu> <20080819033710.GD17528@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819033710.GD17528@spacedout.fries.net>
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


* David Fries <david@fries.net> wrote:

> On Mon, Aug 18, 2008 at 08:41:20AM +0200, Ingo Molnar wrote:
> > 
> > applied to tip/x86/urgent, thanks David. I've changed the conditions 
> > to read_cr4_safe() instead - that's cleaner. Could you please check 
> > whether the patch below works fine too on your box?
> 
> Yes the 486 suspends and resumes with this patch.

good - it's now upstream and should show up in 2.6.27-rc4 as well.

> Is there any known problem with no_console_suspend and serial 
> consoles?  It worked to print the oops for me to track this down, and 
> Documentation/kernel-parameters.txt says it is known to work with 
> serial consoles, but on resume only kernel messages can output to the 
> serial console.  The getty on the serial port can't raed or write and 
> processes trying to write to the port just hang without getting any 
> data across.  The serial port works fine across suspends without the 
> no_console_suspend argument.  Does anyone else see this?

i've had trouble no end with getting even kernel messages out to the 
serial console during critical phases of suspend/resume. (especially in 
combination with earlyprintk=ttyS0 - not surprisingly)

Especially during resume the UART is initialized back to something 
really slow - 300 bauds or 9600 bauds. (depends on the chipset i guess) 
So even though it works, it will only worked reliably when i 
standardized all my baud settings to that very low setting.

	Ingo
