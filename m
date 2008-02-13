Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbYBMWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbYBMWf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYBMWfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:35:14 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58647 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYBMWfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:35:12 -0500
Date: Thu, 14 Feb 2008 00:34:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Emelyanov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
	symbols going away
Message-ID: <20080213223455.GB12383@cs181133002.pp.htv.fi>
References: <1202941327.18204.11.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1202941327.18204.11.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:22:06PM -0800, Harvey Harrison wrote:
>...
> --- /dev/null
> +++ b/Documentation/feature-removal/exported-symbols.txt
> @@ -0,0 +1,34 @@
> +The following is a list of symbols whose exports are unused in the kernel
> +tree and will be removed.  Unused symbols are both increasing the size of
> +the kernel binary and are often a sign of a "wrong API"
> +
> +When adding a symbol, change to EXPORT_UNUSED_SYMBOL{_GPL} in the source
> +and schedule for removal in the first stable version the unused symbol is
> +marked in + 3.  This will give out of tree code ~9 months to stop using the
> +export or make a case why the export should be kept.
> +
> +CONFIG_UNUSED_SYMBOLS is provided to enable unused symbol exports.
> +
> +Please include the following:
> +
> +What:	the_symbol
> +Where:	filename the symbol is exported from
> +When:	next stable version+3
> +Why:	a reason would be nice
> +
> +---------------------------
> +
> +What:	__inet_hash_connect
> +Where:	net/ipv4/inet_hashtables.c
> +When:	2.6.28
> +Why:	No in tree users
> +
> +---------------------------
> +
> +What:	io_delay_type
> +Where:	arch/x86/kernel/io_delay.c
> +When:	2.6.28
> +Why:	No in tree users
> +
> +---------------------------
>...

NAK.

It's a well-known and documented fact that we not have a stable API for 
modules.

And as long as we anyway break the modules API in so many other cases 
with each kernel release there's simply no point in not removing exports 
immediately.

Oh, and for increasing the amount of nonsense even further, you should 
explain why unused exports that just sneaked into 2.6.25-rc1 must be 
shipped in 4 stable kernels before they can be removed.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

