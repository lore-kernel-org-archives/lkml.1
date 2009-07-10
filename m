Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZGJHTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZGJHTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZGJHTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:19:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:12556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZGJHTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:19:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,377,1243839600"; 
   d="scan'208";a="429041514"
Date: Fri, 10 Jul 2009 15:17:53 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 11/12] SFI, PCI: Hook MMCONFIG
Message-ID: <20090710151753.05848348@feng-desktop>
In-Reply-To: <20090710055229.GD22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
	<24fe646fcbbd9049850de4ac57cf6a67846b38c4.1247025117.git.len.brown@intel.com>
	<20090710055229.GD22218@elte.hu>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 13:52:29 +0800
Ingo Molnar <mingo@elte.hu> wrote:

> 
> > @@ -606,7 +607,9 @@ static void __init __pci_mmcfg_init(int early)
> >  	}
> >  
> >  	if (!known_bridge)
> > -		acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
> > +		if (acpi_table_parse(ACPI_SIG_MCFG,
> > pci_parse_mcfg))
> > +			sfi_acpi_table_parse(ACPI_SIG_MCFG, NULL,
> > NULL, 0,
> > +				pci_parse_mcfg);
> 
> Please introduce one common/generic helper:
> 
> 		x86_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
> 
> and do the fallback in that helper. We generally want to try ACPI 
> first, SFI second. That helper makes it easier to add such fallback 
> in other places as well, and will de-uglify the above code as well.
>

Should we have a new acpi_sfi.c or .h to contain all these helper functions?
I think it is not appropriate to put it to either ACPI or SFI code.

Also, ACPI and SFI code under arch/x86/kernel have lots of similar code
in cpu/io-apic parsing, we thought about extracting these sharable codes
out and move them to apic.c/io_apic.c, but don't know if this will
uglify current apic/ioapic code? how do you think about it?

Thanks,
Feng 
 
> 	Ingo
