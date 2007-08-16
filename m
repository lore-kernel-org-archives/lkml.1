Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbXHPX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbXHPX0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbXHPX0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:26:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbXHPX0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:26:03 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: boot correctly with "nosmp" or "maxcpus=0"
Date: Fri, 17 Aug 2007 01:25:56 +0200
User-Agent: KMail/1.9.6
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200708160332.30732.lenb@kernel.org> <20070816193649.GA16680@bingen.suse.de> <200708161906.47278.lenb@kernel.org>
In-Reply-To: <200708161906.47278.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708170125.57416.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007 01:06:47 Len Brown wrote:
> On Thursday 16 August 2007 15:36, Andi Kleen wrote:
> > > @@ -157,10 +162,13 @@ early_param("nosmp", nosmp);
> > >  static int __init maxcpus(char *str)
> > >  {
> > >  	get_option(&str, &max_cpus);
> > > -	return 1;
> > > +	if (max_cpus == 0)
> > > +		disable_ioapic_setup();
> > 
> > I must say I never liked that maxcpus=0 ... does disable the APIC
> > too. There can be situations where you want only a single CPU,
> > but still full APICs because modern systems don't boot without. 
> 
> maxcpus=1 will give you that.
> new kernel-parameters.txt in patch should say this
> (matching what comment in the code says)

Ok.

> The only reason I fixed it instead of changing it per above
> is because people may be used to it in non ACPI configurations
> and get surprised when it doesn't do exactly the same
> thing (or in this case doesn't boot at all) in an ACPI configuration.

Patch is fine for me.

-Andi
