Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbXHBTPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbXHBTPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXHBTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:15:31 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58553 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368AbXHBTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:15:30 -0400
Date: Thu, 2 Aug 2007 21:15:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andreas Schwab <schwab@suse.de>,
       trenn@suse.de, Jan Dittmer <jdi@l4x.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       rusty@rustcorp.com.au, jcm@jonmasters.org
Subject: Re: scripts/mod/file2alias.c cross compile problem
Message-ID: <20070802191509.GX3972@stusta.de>
References: <jewswdvqpt.fsf@sykes.suse.de> <617E1C2C70743745A92448908E030B2A02156CC1@scsmsx411.amr.corp.intel.com> <20070802180903.GD2431@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070802180903.GD2431@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 08:09:03PM +0200, Sam Ravnborg wrote:
> 
> I second this. For anything visible in userspace from
> include/* we require usage of the kernel specific
> __u8, __u16, __u32, __u64 typedefs but for device_id we accept
> kernel_ulong_t which result in the following crap in
> file2alias.c:
> 
> /* We use the ELF typedefs for kernel_ulong_t but bite the bullet and
>  * use either stdint.h or inttypes.h for the rest. */
> #if KERNEL_ELFCLASS == ELFCLASS32
> typedef Elf32_Addr      kernel_ulong_t;
> #define BITS_PER_LONG 32
> #else
> typedef Elf64_Addr      kernel_ulong_t;
> #define BITS_PER_LONG 64
> #endif
> 
> And we ought to have __u64 available.
> See for example types.h from asm-i386:
> #if defined(__GNUC__) && !defined(__STRICT_ANSI__)
> typedef __signed__ long long __s64;
> typedef unsigned long long __u64;
> #endif


You are talking about something different than the current problem.

The current problem is that when crosscompiling we get a different 
_padding_ due to file2alias.c being compiled with HOSTCC.


What you are talking about is a different issue, and I can't talk about 
it since I don't understand these interactions between modpost and depmod.


> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

