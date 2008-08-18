Return-Path: <linux-kernel-owner+w=401wt.eu-S1751156AbYHREPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbYHREPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYHREPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:15:24 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62732 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751501AbYHREPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:15:24 -0400
Date: Mon, 18 Aug 2008 05:14:50 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Fries <david@fries.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
In-Reply-To: <20080818040340.GB17528@spacedout.fries.net>
Message-ID: <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl>
References: <20080818040340.GB17528@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008, David Fries wrote:

> arch/x86/power/cpu_32.c __save_processor_state calls read_cr4()
> only a i486 CPU doesn't have the CR4 register.  Trying to read it
> produces an invalid opcode oops during suspend to disk.
[...]
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 81e5ab6..bd0f2a3 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -86,7 +86,9 @@ int acpi_save_state_mem(void)
>  #endif /* !CONFIG_64BIT */
>  
>  	header->pmode_cr0 = read_cr0();
> -	header->pmode_cr4 = read_cr4();
> +	/* cr4 was introduced in the Pentium CPU */
> +	if (boot_cpu_data.x86 >= 5)
> +		header->pmode_cr4 = read_cr4();
>  	header->realmode_flags = acpi_realmode_flags;
>  	header->real_magic = 0x12345678;
>  

 NACK.  Later i486 chips do have CR4 -- for PSE, VME, etc. (the set of
features varies across the line).  Use a fixup as elsewhere or something.

  Maciej
