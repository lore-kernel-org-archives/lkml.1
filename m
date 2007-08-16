Return-Path: <linux-kernel-owner+w=401wt.eu-S1763596AbXHPXHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763596AbXHPXHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbXHPXHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:07:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:44113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbXHPXG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:06:59 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] ACPI: boot correctly with "nosmp" or "maxcpus=0"
Date: Thu, 16 Aug 2007 19:06:47 -0400
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200708160332.30732.lenb@kernel.org> <20070816193649.GA16680@bingen.suse.de>
In-Reply-To: <20070816193649.GA16680@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708161906.47278.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2007 15:36, Andi Kleen wrote:
> > @@ -157,10 +162,13 @@ early_param("nosmp", nosmp);
> >  static int __init maxcpus(char *str)
> >  {
> >  	get_option(&str, &max_cpus);
> > -	return 1;
> > +	if (max_cpus == 0)
> > +		disable_ioapic_setup();
> 
> I must say I never liked that maxcpus=0 ... does disable the APIC
> too. There can be situations where you want only a single CPU,
> but still full APICs because modern systems don't boot without. 

maxcpus=1 will give you that.
new kernel-parameters.txt in patch should say this
(matching what comment in the code says)

> It's the old traditional documented semantics though,
> but on the other hand if it never worked with ACPI i guess people are
> not relying on it.
> 
> So perhaps it would be better to change that? 
> Or add a new option to limit CPUs without disabling ACPIC?

If we cared not for tradition, I'd delete "nosmp",
maxcpus=0 would be a synonym for maxcpus=1
and if you didn't want an IOAPIC, you'd use "noapic"
(heh, don't get me started on the noapic vs. nolapic legacy:-)

The only reason I fixed it instead of changing it per above
is because people may be used to it in non ACPI configurations
and get surprised when it doesn't do exactly the same
thing (or in this case doesn't boot at all) in an ACPI configuration.

Either way is fine with me, but I can't leave it as
"nosmp" and "maxcpus=0" not booting at all on ACPI boxes.

thanks,
-Len
