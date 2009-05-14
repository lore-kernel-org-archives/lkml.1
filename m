Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbZENRox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbZENRox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZENRom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:44:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:33258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZENRol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:44:41 -0400
Message-ID: <4A0C584E.2060409@kernel.org>
Date: Thu, 14 May 2009 10:43:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86/acpi: calling mp_config_acpi_gsi in mp_register_gsi
 -v2
References: <4A01C35C.7060207@kernel.org> <4A01C387.7090103@kernel.org> <alpine.LFD.2.00.0905141154390.19537@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905141154390.19537@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> mp_config_acpi_gsi() has been dead code since the day it went into 2.6.27.
> Rather than repairing that, I'd rather see it removed.
> 
> The justification for 2944e16b25e7fb8b5ee0dd9dc7197a0f9e523cfd
> "x86: update mptable" was:
> 
>     1. kexec kernel with acpi=off
>     2. work around BIOSes where acpi routing is working, but mptable is
>        not right, so can use kernel/kexec to start other OSes that don't have
>        good acpi support.
>     
>     command line: update_mptable
> 
> So this is a command line option to allow
> MPS code to call into ACPI code to support kexec from an ACPI
> mode into non-ACPI mode -- all without a single comment in the code.
> 
> I'm not convinced that the scenario that this code was
> intended to address justifies adding unreadable code to
> an area of the kernel which is notoriously over-complicated
> and fragile.  Doing so is the opposite of optimizing for maintenance.

also could use it to show BIOS engineers what is correct mptable and that could help them to 
fix the problem in mptable creating when the system have a lot pci cards with bridge in the card.

> 
> No, I don't want to see any MPS code ever call into ACPI code.

how about:
make enable_update_mptable global, and in mp_register_gsi only call mp_config_acpi_gsi()
when enable_update_mptable == 1

YH

