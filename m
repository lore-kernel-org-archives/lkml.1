Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZF2DBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZF2DBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZF2DBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:01:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:16947 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbZF2DBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,306,1243839600"; 
   d="scan'208";a="470365605"
Date: Mon, 29 Jun 2009 10:59:33 +0800
From: Feng Tang <feng.tang@intel.com>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Message-ID: <20090629105933.56c6336f@feng-desktop>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755641A44CB@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com>
	<20090626070720.GB14078@elte.hu>
	<43F901BD926A4E43B106BF17856F0755641A44CB@orsmsx508.amr.corp.intel.com>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jun 2009 01:18:50 +0800
"Pan, Jacob jun" <jacob.jun.pan@intel.com> wrote:

> >> -#ifdef CONFIG_ACPI
> >> +#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)
> >
> >Please add a new helper non-interactive Kconfig symbol instead of
> >increasing the #ifdef jungle.
> >
> [[JPAN]] I agreed, maybe this should be part of the SFI patch or
> already have similar plans?

Yes, Ingo has given similar comments for SFI code. I thought about 2
methods for this:
1. these "#ifdef...#endif" covers three functions:
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);	
how about just completely removing the "#ifdef...#endif", as ACPI/SFI 
codes are heavily used on x86 platforms, and it may bring one hundred
additional bytes for None-ACPI/SFI platforms 
2. create a new "CONFIG_ACPI_SFI" option, using this new option to cover
this case, and let "ACPI"/"SFI" option select it in Kconfig files

any comments? thanks

- Feng
