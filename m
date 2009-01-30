Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZA3PBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZA3PBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZA3PBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:01:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34559 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbZA3PBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:01:36 -0500
Date: Fri, 30 Jan 2009 16:01:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
Message-ID: <20090130150125.GF31009@elte.hu>
References: <20090129.155852.161923905.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129.155852.161923905.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> While working on an NMI watchdog implementation on sparc64 I noticed 
> what seems to be a peculiar behavior of the NMI timer int oprofile 
> support on x86.
> 
> When the NMI watchdog tests itself at boot timer we start with nmi_hz 
> equal to HZ.
> 
> After the NMI watchdog self-test passes, nmi_hz is reduced down to '1'.
> 
> The NMI timer int oprofile support simply uses DIE_NMI notifiers for 
> it's implementation.  But I don't see anything in the code of 
> arch/x86/oprofile/nmi_timer_int.c nor the NMI watchdog infrastructure 
> which will re-adjust nmi_hz back to HZ or something similar.
> 
> Am I missing something?

Reducing it to 1 HZ was kind of a performance hack: running NMIs at HZ 
needlessly interrupts the CPU HZ times a second. It's more than enough to 
have 1 nmi-watchdog tick per second to notice deadlocks that take longer 
than 5 seconds.

Can you see a problem with that approach, or was this just a question 
about why it's reduced to 1 Hz?

	Ingo
