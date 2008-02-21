Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbYBUUij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbYBUUij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933848AbYBUUiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:38:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933701AbYBUUiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:38:04 -0500
Date: Thu, 21 Feb 2008 21:37:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: don't print a warning when MTRR are blank and
	running in KVM
Message-ID: <20080221203748.GA9031@elte.hu>
References: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> -	if (!highest_pfn) {
> +	if (!highest_pfn && !kvm_para_available()) {
>  		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
>  		WARN_ON(1);
> -		return 0;
>  	}
>  
> +	if (!highest_pfn)
> +		return 0;

hm, why not have a single test for !highest_pfn:

	if (!highest_pfn) {
		if (!kvm_para_available()) {
  			printk(KERN_WARNING
			       "WARNING: strange, CPU MTRRs all blank?\n");
	  		WARN_ON(1);
		}
		return 0;
	}

? But yeah, your patch looks good otherwise.

I'm not sure how we could detect pure Qemu instances - perhaps it should 
define some special MSR or something?

	Ingo
