Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZCACB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZCACB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 21:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZCACBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 21:01:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZCACBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 21:01:49 -0500
Date: Sat, 28 Feb 2009 21:01:47 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Brian Maly <bmaly@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix DMI for EFI
Message-ID: <20090301020147.GE28503@bombadil.infradead.org>
References: <49A9E5DB.8070203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A9E5DB.8070203@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 08:33:15PM -0500, Brian Maly wrote:
> -	dmi_scan_machine();
> -
> -	dmi_check_system(bad_bios_dmi_table);
> -
>  	/*
>  	 * VMware detection requires dmi to be available, so this
>  	 * needs to be done after dmi_scan_machine, for the BP.

This init_hypervisor comment looks important, no? Possibly it needs
to be moved after the new placement? Doesn't look like the probe_roms
will be an issue.

regards, Kyle

> @@ -792,6 +788,10 @@ void __init setup_arch(char **cmdline_p)
>  	if (efi_enabled)
>  		efi_init();
>  
> +	dmi_scan_machine();
> +	
> +	dmi_check_system(bad_bios_dmi_table);
> +
>  #ifdef CONFIG_X86_32
>  	if (ppro_with_ram_bug()) {
>  		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,

