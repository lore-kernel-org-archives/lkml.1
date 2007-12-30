Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXL3OzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXL3OzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbXL3OzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:55:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbXL3OzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:55:11 -0500
Date: Sun, 30 Dec 2007 15:51:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: clear IO_APIC before enabing apic error
	vector. v2
Message-ID: <20071230145115.GR16946@elte.hu>
References: <200712291952.20455.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712291952.20455.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> please check if you can replace the one in the x86-mm
> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=ffcbdc220a1520d006a837f33589c7c19ffbeb76
> 
> the updated one avoid one link warning.

please send delta patches instead - so that we can review the changes.

> this is the updated verison that take enable_IO_APIC as extra call for 
> setup_local_APIC to avoid linking warning.

hm, what link warning did you get? Perhaps the following __cpuinit:

> -void __cpuinit setup_local_APIC (void)

does not mix well with an __init call:

> +void __init enable_IO_APIC(void)

and you hack it around by using a function pointer. Nasty and still 
buggy. The proper solution would be to mark enable_IO_APIC as __cpuinit 
too (or something like that).

	Ingo
