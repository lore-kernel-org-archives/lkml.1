Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbYA1PBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbYA1PBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYA1PBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:01:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYA1PBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:01:05 -0500
Date: Mon, 28 Jan 2008 16:00:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
Message-ID: <20080128150022.GE27928@elte.hu>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47992D0E.2070700@zytor.com> <20080125074910.GD4134@ucw.cz> <200801252302.52164.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801252302.52164.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Speaking of cleanups, the following one is applicable IMO.

> --- linux-2.6.orig/arch/x86/mm/init_32.c
> +++ linux-2.6/arch/x86/mm/init_32.c
> @@ -444,23 +444,23 @@ static void __init pagetable_init (void)
>  	paravirt_pagetable_setup_done(pgd_base);
>  }
>  
> -#if defined(CONFIG_HIBERNATION) || defined(CONFIG_ACPI)
> +#ifdef CONFIG_SUSPEND
>  /*
>   * Swap suspend & friends need this for resume because things like the intel-agp
>   * driver might have split up a kernel 4MB mapping.
>   */
> -char __nosavedata swsusp_pg_dir[PAGE_SIZE]
> +char swsusp_pg_dir[PAGE_SIZE]

thanks, applied.

	Ingo
