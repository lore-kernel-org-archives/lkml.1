Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXJ2Q3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXJ2Q3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbXJ2Q3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:29:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbXJ2Q3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:29:00 -0400
Date: Mon, 29 Oct 2007 09:28:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Permit the memory to be located elsewhere in NOMMU
 mode
In-Reply-To: <20071029152028.14124.50739.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.0.999.0710290926140.30120@woody.linux-foundation.org>
References: <20071029152028.14124.50739.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Oct 2007, David Howells wrote:
>  
> -__page_offset = 0xc0000000;		/* start of area covered by struct pages */
> +/* start of area covered by struct pages */
> +#if defined(CONFIG_UCPAGE_OFFSET_20000000)
> +__page_offset = 0x20000000;
> +#elif defined(CONFIG_UCPAGE_OFFSET_40000000)
> +__page_offset = 0x40000000;
...

Please don't do these kinds of things in the source code.

Do them in the Kconfig language where it belongs, and where it makes much 
more sense.

See, for example, arch/x86/Kconfig.i386:

	config PAGE_OFFSET
	        hex
	        default 0xB0000000 if VMSPLIT_3G_OPT
	        default 0x80000000 if VMSPLIT_2G
	        default 0x78000000 if VMSPLIT_2G_OPT
	        default 0x40000000 if VMSPLIT_1G
	        default 0xC0000000

Notice? Even the syntax is much cleaner!

		Linus
