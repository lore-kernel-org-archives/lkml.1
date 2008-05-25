Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYEYBbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYEYBbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 21:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYEYBbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 21:31:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbYEYBbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 21:31:36 -0400
Date: Sat, 24 May 2008 18:30:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: use defconfig as last resort
In-Reply-To: <20080524203748.GA2343@uranus.ravnborg.org>
Message-ID: <alpine.LFD.1.10.0805241825460.3081@woody.linux-foundation.org>
References: <20080524192540.GA28067@uranus.ravnborg.org> <alpine.LFD.1.10.0805241320200.3081@woody.linux-foundation.org> <20080524203748.GA2343@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 24 May 2008, Sam Ravnborg wrote:
> 
> When using "make oldconfig" with no .config
> present try the list from init/Kconfig DEFCONFIG_LIST
> before resorting to use one of the defconfigs.

Hmm. Why does placement matter here?

Also:

> +config DEFCONFIG_LIST
> +	string
> +	depends on X86_32
> +	option defconfig_list
> +	default "arch/x86/configs/i386_defconfig"
> +
> +config DEFCONFIG_LIST
> +	string
> +	depends on X86_64
> +	option defconfig_list
> +	default "arch/x86/configs/x86_64_defconfig"
> +

Wouldn't this be cleaner as just *one* entry, and then just have 
different default statements, ie something like

    config DEFCONFIG_LIST
	string
	option defconfig_list
	default "arch/x86/configs/i386_defconfig" if X86_32
	default "arch/x86/configs/x86_64_defconfig" if X86_64

instead?

		Linus
