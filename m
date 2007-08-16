Return-Path: <linux-kernel-owner+w=401wt.eu-S1763988AbXHPSm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763988AbXHPSm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 14:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbXHPSms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 14:42:48 -0400
Received: from mail.suse.de ([195.135.220.2]:35854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbXHPSmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 14:42:47 -0400
Date: Thu, 16 Aug 2007 21:36:49 +0200
From: Andi Kleen <ak@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <ak@suse.de>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: boot correctly with "nosmp" or "maxcpus=0"
Message-ID: <20070816193649.GA16680@bingen.suse.de>
References: <200708160332.30732.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708160332.30732.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -157,10 +162,13 @@ early_param("nosmp", nosmp);
>  static int __init maxcpus(char *str)
>  {
>  	get_option(&str, &max_cpus);
> -	return 1;
> +	if (max_cpus == 0)
> +		disable_ioapic_setup();

I must say I never liked that maxcpus=0 ... does disable the APIC
too. There can be situations where you want only a single CPU,
but still full APICs because modern systems don't boot without. 

It's the old traditional documented semantics though,
but on the other hand if it never worked with ACPI i guess people are
not relying on it.

So perhaps it would be better to change that? 
Or add a new option to limit CPUs without disabling ACPIC?

-Andi
