Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbXGQMzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbXGQMzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXGQMzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:55:45 -0400
Received: from ns1.suse.de ([195.135.220.2]:52844 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbXGQMzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:55:45 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch-mm 14/33] x86_64: Consolidate tsc calibration
Date: Tue, 17 Jul 2007 14:51:23 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de> <20070715155541.282543247@inhelltoy.tec.linutronix.de>
In-Reply-To: <20070715155541.282543247@inhelltoy.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171451.23668.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2007 18:10:55 Thomas Gleixner wrote:
> Move the TSC calibration code to tsc.c. Reimplement it so the
> pm timer can be used as a reference as well.

Why is the pm timer better than the PIT for this? 

I've had mixed success with the pmtimer too.

>
> Index: linux-2.6.22-rc6-mm/include/asm-i386/tsc.h
> ===================================================================
> --- linux-2.6.22-rc6-mm.orig/include/asm-i386/tsc.h	2007-07-15 17:26:45.000000000 +0200
> +++ linux-2.6.22-rc6-mm/include/asm-i386/tsc.h	2007-07-15 17:34:42.000000000 +0200
> @@ -71,4 +71,8 @@ extern void init_tsc_clocksource(void);
>  extern void check_tsc_sync_source(int cpu);
>  extern void check_tsc_sync_target(void);
>  
> +#ifdef CONFIG_X86_64
> +extern void tsc_calibrate(void);
> +#endif

The ifdef shouldn't be needed?

-Andi
