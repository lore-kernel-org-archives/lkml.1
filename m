Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYDKKvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYDKKvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbYDKKvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:51:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46623 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbYDKKvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:51:23 -0400
Date: Fri, 11 Apr 2008 12:51:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080411105108.GA1844@elte.hu>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org> <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz> <20080410094554.GA10321@ucw.cz> <Pine.LNX.4.64.0804110122470.3896@jikos.suse.cz> <20080411104902.GA8734@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411104902.GA8734@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
> index 6c90fb9..8195c37 100644
> --- a/lib/smp_processor_id.c
> +++ b/lib/smp_processor_id.c
> @@ -35,6 +35,13 @@ unsigned int debug_smp_processor_id(void
>  		goto out;
>  
>  	/*
> +	 * It is valid to assume CPU-locality if there's just one
> +	 * CPU active
> +	 */
> +	if (num_online_cpus() == 1)
> +		goto out;

thanks Pavel, i picked this up into sched-devel.git - it makes sense 
independently of whether it solves the warning.

	Ingo
