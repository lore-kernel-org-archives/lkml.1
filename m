Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbZKDAxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbZKDAxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZKDAxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:53:00 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:49159 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZKDAw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:52:58 -0500
Date: Wed, 4 Nov 2009 00:53:02 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       garyhade@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
In-Reply-To: <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>
Message-ID: <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>
References: <20091026230001.947855317@sbs-t61.sc.intel.com> <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, tip-bot for Suresh Siddha wrote:

> Commit-ID:  b3ec0a37a7907813bb4fb85a2d94102c152470b7
> Gitweb:     http://git.kernel.org/tip/b3ec0a37a7907813bb4fb85a2d94102c152470b7
> Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> AuthorDate: Mon, 26 Oct 2009 14:24:35 -0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 2 Nov 2009 15:56:36 +0100
> 
> x86: Use EOI register in io-apic on intel platforms
> 
> IO-APIC's in intel chipsets support EOI register starting from
> IO-APIC version 2. Use that when ever we need to clear the
> IO-APIC RTE's RemoteIRR bit explicitly.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Acked-by: Gary Hade <garyhade@us.ibm.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> LKML-Reference: <20091026230001.947855317@sbs-t61.sc.intel.com>
> [ Marked use_eio_reg as __read_mostly, fixed small details ]
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
[...]
> +static int ioapic_supports_eoi(void)
> +{
> +	struct pci_dev *root;
> +
> +	root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
> +	if (root && root->vendor == PCI_VENDOR_ID_INTEL &&
> +	    mp_ioapics[0].apicver >= 0x2) {
> +		use_eoi_reg = 1;
> +		printk(KERN_INFO "IO-APIC supports EOI register\n");
> +	} else
> +		printk(KERN_INFO "IO-APIC doesn't support EOI\n");
> +
> +	return 0;
> +}

 This is wrong -- the 82093AA I/O APIC has its version set to 0x11 and it 
does not support the EOI register.  Similarly I/O APICs integrated into 
the 82379AB south bridge and the 82374EB/SB EISA component.

 Overall values below 0x10 are reserved for the 82489DX -- are you sure 
you didn't mean 0x12 or 0x20?

  Maciej
