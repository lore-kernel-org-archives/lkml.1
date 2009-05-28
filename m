Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbZE1Msx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbZE1Msx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762032AbZE1Msq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:48:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54216 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762210AbZE1Msp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:48:45 -0400
Date: Thu, 28 May 2009 14:48:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Larry H." <research@subreption.com>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090528124840.GB1421@ucw.cz>
References: <20090520183045.GB10547@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520183045.GB10547@oblivion.subreption.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Index: linux-2.6/mm/Kconfig
> ===================================================================
> --- linux-2.6.orig/mm/Kconfig
> +++ linux-2.6/mm/Kconfig
> @@ -155,6 +155,26 @@ config PAGEFLAGS_EXTENDED
>  	def_bool y
>  	depends on 64BIT || SPARSEMEM_VMEMMAP || !NUMA || !SPARSEMEM
>  
> +config PAGE_SENSITIVE
> +	bool "Support for selective page sanitization"
> +	help
> +	 This option provides support for honoring the sensitive bit
> +	 in the low level page allocator. This bit is used to mark
> +	 pages that will contain sensitive information (such as
> +	 cryptographic secrets and credentials).
> +
> +	 Pages marked with the sensitive bit will be sanitized upon
> +	 release, to prevent information leaks and data remanence that
> +	 could allow Iceman/coldboot attacks to reveal such data.
> +
> +	 If you are unsure, select N. This option might introduce a
> +	 minimal performance impact on those subsystems that make
> +	 use of the flag associated with the sensitive bit.
> +
> +	 If you use the cryptographic API or want to prevent tty
> +	 information leaks locally, you most likely want to enable
> +	 this.

This should not be configurable. Runtime config, defaulting to
'sanitize' may make some sense, but... better just be secure.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

