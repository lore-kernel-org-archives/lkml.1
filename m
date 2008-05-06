Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYEFLtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYEFLtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYEFLsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:48:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYEFLsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:48:55 -0400
Date: Tue, 6 May 2008 13:48:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 lies about PAT not being available
Message-ID: <20080506114839.GD32591@elte.hu>
References: <18464.5177.649312.999486@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18464.5177.649312.999486@harpo.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Booting 2.6.26-rc1 on an old Coppermine PIII, I'm greeted with:
> 
> >Linux version 2.6.26-rc1 (mikpe@dryhop) (gcc version 4.2.3) #1 Mon May 5 21:49:49 CEST 2008
> >BIOS-provided physical RAM map:
> > BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
> > BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
> > BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> > BIOS-e820: 0000000000100000 - 000000002ffec000 (usable)
> > BIOS-e820: 000000002ffec000 - 000000002ffef000 (ACPI data)
> > BIOS-e820: 000000002ffef000 - 000000002ffff000 (reserved)
> > BIOS-e820: 000000002ffff000 - 0000000030000000 (ACPI NVS)
> > BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
> >CPU and/or kernel does not support PAT.
> 
> I know about Intel's PAT erratum (only 4 PAT entries work) and 
> understand that the kernel might not want to use a half-broken PAT 
> implementation, but the statement above is blatantly false: the kernel 
> IS built with PAT support and the CPU DOES have (half-broken) PAT HW 
> support as /proc/cpuinfo from earlier kernels confirms.

well the code is just being overly conservative, and the message is 
right: the kernel does not support PAT on that hw. Yet.

Please send us a patch and test whether it's working on your box? That's 
how the PAT code evolved: it initially was only enabled on a very small 
subset of CPUs. We can enable it on more CPUs if people test it.

To be conservative, please make the code emit a printk that this is PAT 
on not fully-working hw platform (only 4 PAT entries work). If there 
_is_ some erratum on that CPU affecting PAT reliability down the line, 
we at least want to have some clue in the syslog.

	Ingo
