Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbXEJUk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbXEJUk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761363AbXEJUks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:40:48 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4335 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761465AbXEJUkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:40:47 -0400
Date: Thu, 10 May 2007 21:40:38 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Chris Wedgwood <cw@f00f.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510204037.GE29713@flint.arm.linux.org.uk>
Mail-Followup-To: Chris Wedgwood <cw@f00f.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>
References: <20070510203417.GA23019@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510203417.GA23019@tuatara.stupidest.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 01:34:18PM -0700, Chris Wedgwood wrote:
> MODPOST seems to be spewing bogus warnings.  It's not clear how best
> to fix it so perhaps we should silence it for now?

I agree.  Example bogus warning:

WARNING: arch/arm/mach-iop32x/built-in.o - Section mismatch:
 reference to .init.text: from .data between 'iq80321_timer'
 (at offset 0x428) and 'iq80321_serial_device'

c04088fc d iq80321_timer
c0408950 d iq80321_serial_device

It's completely unclear what is referencing what, what the two named
symbols mean, and even what "at offset" relates to.

What I can say is that iq80321_timer doesn't reference iq80321_serial_device
nor vice versa, and iq80321_timer is far smaller than 0x428 bytes.

> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 113dc77..bd6fe7b 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -872,6 +872,10 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
>  				 sechdrs[hdr->e_shstrndx].sh_offset;
>  	const char *secname = secstrings + sechdrs[sym->st_shndx].sh_name;
>  
> +	/* FIXME: this function doesn't work correctly anymore, it's
> +	 * not clear if it should be fixed or removed. */
> +	return;
> +
>  	find_symbols_between(elf, r.r_offset, fromsec, &before, &after);
>  
>  	refsym = find_elf_symbol(elf, r.r_addend, sym);

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
