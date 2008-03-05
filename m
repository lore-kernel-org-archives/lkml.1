Return-Path: <linux-kernel-owner+w=401wt.eu-S1761873AbYCEQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761873AbYCEQ4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761323AbYCEQ4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:56:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761322AbYCEQ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:56:15 -0500
Date: Wed, 5 Mar 2008 13:53:20 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
Message-ID: <20080305165320.GJ20230@blackpad>
References: <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk> <20080305155930.GI20230@blackpad> <47CEC561.6050008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CEC561.6050008@zytor.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 08:08:01AM -0800, H. Peter Anvin wrote:
> Eduardo Habkost wrote:
> >>
> >>diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> >>index 3bad477..2341492 100644
> >>--- a/arch/x86/xen/setup.c
> >>+++ b/arch/x86/xen/setup.c
> >>@@ -38,7 +38,8 @@ char * __init xen_memory_setup(void)
> >> 	unsigned long max_pfn = xen_start_info->nr_pages;
> >> 
> >> 	e820.nr_map = 0;
> >>-	add_memory_region(0, PFN_PHYS(max_pfn), E820_RAM);
> >>+	add_memory_region(0, LOWMEMSIZE(), E820_RAM);
> >>+	add_memory_region(HIGH_MEMORY, PFN_PHYS(max_pfn)-HIGH_MEMORY, 
> >>E820_RAM);
> >
> >Won't this waste 300+ KB of Perfectly Good RAM? Or I understood it
> >incorrectly?
> >
> >I am aware that it would take more work to tell all kernel code that it
> >shouldn't look for BIOS data on this region when running as a domU guest,
> >but it seems that it would be a better solution.
> >
> 
> No, the right thing is for Xen to not try to map RAM in this area.

Why? If the Xen host is telling us there is valid RAM in this area,
why can't we use it?

Existing Xen hosts use those physical address ranges for RAM. We can't
fix this on the e820 map on the guest side without making otherwise-valid
RAM unused.

-- 
Eduardo
