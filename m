Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYCCRti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYCCRti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYCCRt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:49:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35850 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYCCRt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:49:28 -0500
Date: Mon, 3 Mar 2008 18:48:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080303174858.GB25496@elte.hu>
References: <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303151155.GT17932@hjernemadsen.org>
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


* Klaus S. Madsen <ksm@hjernemadsen.org> wrote:

> The following patch solves the segfault, by changing the mmap flags of 
> the video memory area, to allow execution. The patch is against 
> libx86-0.99 available from http://www.codon.org.uk/~mjg59/libx86/
> 
> --- libx86-0.99/x86-common.c	2006-09-08 00:44:27.000000000 +0200
> +++ libx86-0.99.new/x86-common.c	2008-03-01 10:08:25.000000000 +0100
> @@ -232,7 +232,7 @@
>  	}
>  
>  	m = mmap((void *)0xa0000, 0x100000 - 0xa0000,
> -	 PROT_READ | PROT_WRITE,
> +	 PROT_READ | PROT_WRITE | PROT_EXEC,

are you sure you ID-ed the right commit that broke things?

while requiring PROT_EXEC is fine, breaking existing user-space apps 
over that is not fine. So are you absolutely sure that by reverting that 
PWT|PCD commit, s2ram again starts to work? That's utmost weird...

perhaps there's some CPU bug that causes NX to _NOT_ work if only PCD is 
used (not PCD|PWT). Seems like a pretty unlikely scenario though.

	Ingo
