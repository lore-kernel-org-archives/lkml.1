Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYCZXAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYCZXAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYCZXAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:00:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbYCZXAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:00:32 -0400
Date: Thu, 27 Mar 2008 00:00:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080326230017.GA21017@elte.hu>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326225407.GA9378@elf.ucw.cz>
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

> @@ -733,8 +735,8 @@ static struct pci_driver agp_amd64_pci_d
>  	.probe		= agp_amd64_probe,
>  	.remove		= agp_amd64_remove,
>  #ifdef CONFIG_PM
> -	.suspend	= agp_amd64_suspend,
> -	.resume		= agp_amd64_resume,
> +	.suspend_late	= agp_amd64_suspend,
> +	.resume_early	= agp_amd64_resume,
>  #endif

ah, makes sense. I've queued up your fix in x86.git (sans the debug 
printks), please send your signoff once you can verify that it solves 
the hibernation hang on your box and we'll push it into 2.6.25.

	Ingo
