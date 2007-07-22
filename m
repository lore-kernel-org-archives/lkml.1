Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXGVWyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXGVWyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762810AbXGVWyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:54:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:45319 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761790AbXGVWyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XRyErRiJkqr3qa636ppy12vpuaGZEnFUqMptSipG8u9ziB5MJF16xv8gbEyTyTvJ+J47c/nxv31nUpHD4C3KCxoU5BpvMp2IDJAtw7p3bYJnKXVMPOhtEP9xFKo7QO96Ah8b7j/lkkvMG/GXvOFrcOmOOMe7zmsVYkfqp9Y/JnA=
Message-ID: <86802c440707221554p3866fdc8j34f49825162dbf1f@mail.gmail.com>
Date: Sun, 22 Jul 2007 15:54:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 3/3] x86_64: offset apicid_to_node before use it before init_cpu_to_node
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       joachim.deguara@amd.com
In-Reply-To: <200707221452.27002.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440707211749x3258891fhbb72a155dc484e86@mail.gmail.com>
	 <200707221452.27002.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Andi Kleen <ak@suse.de> wrote:
> On Sunday 22 July 2007 02:49:41 Yinghai Lu wrote:
> > [PATCH 3/3] x86_64: offset apicid_to_node before use it before init_cpu_to_node
> >
> > When acpi=off or there is no SRAT defined, apicid_to_node is got from K8
> > Northbridge PCI configuration space in k8_scan_nodes() in
> > arch/x86_64/mm/k8toplogy.c.
> > The problem is that it assumes bsp apic id is 0 at that point.
> > For four socket system with Quad core cpus installed, all cpus apic id
> > is offset by 4, and bsp apic id is 4.
> > For eight socket system with dual core cpus installed, all cpus apic id
> > is offset by 2, and bsp apic id is 2.
> > We need offset apicid_to_node array according to boot_cpu_id.--- bsp apic id.
> > before we use apicid_to_node array.
> > boot_cpu_id is only valid init_apic_mappings.
>
> <rant>
> This thing is getting more and more messy. If it gets any more complicated
> I promise I'll rip out the non ACPI support for quad core NUMA completely
> and let it require ACPI.  Even the people who have a religious problem
> with ACPI will need to eventually get over it and LinuxBIOS just has
> to create proper tables, not pile hacks over hacks. It probably was a mistake in
> the first place to add it.
> </rant>
you will need to force every BIOS to have correct SRAT table.
>
> I don't think you can mess with apicid_to_node[] unconditionally here.
> e.g. for the ACPI case or for the Intel NUMA case you'll just break everything.
>
> What you should do is split init_apic_mappings() up and do a early
> call that just checks if the CPU has an APIC and maps it using the
> fixmap and reads boot_cpu_id.  Then you can use that information
> in k8topology.c to create correct tables.

sounds good, i try to split one init_lapic_mappings from init_apic_mappings

Thanks

YH
