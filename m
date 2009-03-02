Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZCBU3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZCBU3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbZCBU3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:29:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZCBU3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:29:32 -0500
Date: Mon, 2 Mar 2009 21:29:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Kevin O'Connor" <kevin@koconnor.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org
Subject: Re: [PATCH] x86: ioremap mptable -v2
Message-ID: <20090302202918.GA14471@elte.hu>
References: <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu> <49A23EE0.8000102@kernel.org> <20090228234127.GA29964@morn.localdomain> <49A9FC9A.2030707@kernel.org> <20090301180420.GA27040@morn.localdomain> <49AB511E.9010507@kernel.org> <20090302101823.GJ20897@elte.hu> <49AC3C8C.8070702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AC3C8C.8070702@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> V3: according to Ingo, seperate get_mpc_size()

No, that was not my suggestion. My suggestion was to separate 
this whole 'else if' branch:

>  	} else if (mpf->physptr) {
> +		struct mpc_table *mpc;
> +		unsigned long size;
>  
> +		size = get_mpc_size(mpf->physptr);
> +		mpc = early_ioremap(mpf->physptr, size);
>  		/*
>  		 * Read the physical hardware table.  Anything here will
>  		 * override the defaults.
>  		 */
> -		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
> +		if (!smp_read_mpc(mpc, early)) {
>  #ifdef CONFIG_X86_LOCAL_APIC
>  			smp_found_config = 0;
>  #endif

... into a helper function - if that improves the code. Your 
patch does early_ioremap, iounmap then ioremap and iounmap - 
quite pointlessly.

You should resist cleanup suggestions that make the code worse, 
even if it comes from a maintainer :-)

	Ingo
