Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbZF2QL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbZF2QL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761102AbZF2QLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:11:21 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:55590 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761029AbZF2QLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:11:11 -0400
Date: Mon, 29 Jun 2009 12:10:48 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Feng Tang <feng.tang@intel.com>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
In-reply-to: <20090629105933.56c6336f@feng-desktop>
Message-id: <alpine.LFD.2.00.0906291204020.5716@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com>
 <20090626070720.GB14078@elte.hu>
 <43F901BD926A4E43B106BF17856F0755641A44CB@orsmsx508.amr.corp.intel.com>
 <20090629105933.56c6336f@feng-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Feng Tang wrote:

> On Sat, 27 Jun 2009 01:18:50 +0800
> "Pan, Jacob jun" <jacob.jun.pan@intel.com> wrote:
> 
> > >> -#ifdef CONFIG_ACPI
> > >> +#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)
> > >
> > >Please add a new helper non-interactive Kconfig symbol instead of
> > >increasing the #ifdef jungle.
> > >
> > [[JPAN]] I agreed, maybe this should be part of the SFI patch or
> > already have similar plans?
> 
> Yes, Ingo has given similar comments for SFI code. I thought about 2
> methods for this:
> 1. these "#ifdef...#endif" covers three functions:
>  extern int io_apic_get_unique_id(int ioapic, int apic_id);
>  extern int io_apic_get_version(int ioapic);
>  extern int io_apic_get_redir_entries(int ioapic);	
> how about just completely removing the "#ifdef...#endif", as ACPI/SFI 
> codes are heavily used on x86 platforms, and it may bring one hundred
> additional bytes for None-ACPI/SFI platforms 
> 2. create a new "CONFIG_ACPI_SFI" option, using this new option to cover
> this case, and let "ACPI"/"SFI" option select it in Kconfig files
> 
> any comments? thanks

I vote #2 -- remove the #ifdefs.
All of these routines are both small and __init,
and the only build that would notice the extra bytes in .text
is the x86 IOAPIC ACPI=n build, which is uncommon today
and becoming more uncommon over time.

The SFI patch series doesn't actually depend on these routines,
the IO-APIC patch depends on them.  So this change
should be in the IO-APIC series.

cheers,
-Len Brown, Intel Open Source Technology Center
