Return-Path: <linux-kernel-owner+w=401wt.eu-S935387AbXGQR6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387AbXGQR6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761724AbXGQR6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:58:42 -0400
Received: from gw.goop.org ([64.81.55.164]:41859 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748AbXGQR6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:58:40 -0400
Message-ID: <469D0318.6060403@goop.org>
Date: Tue, 17 Jul 2007 10:57:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [PATCH] x86: make SMP locks handling interact properly with	CONFIG_DEBUG_RODATA
 (2nd try)
References: <468B5B54.76E4.0078.0@novell.com>
In-Reply-To: <468B5B54.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> +	if (va < MODULES_VADDR) {
> +		change_page_attr(virt_to_page(instr),
> +				 PFN_UP(va + len) - PFN_DOWN(va),
> +#ifdef CONFIG_X86_64
> +				 PAGE_KERNEL_RO);
> +#else
> +				 PAGE_KERNEL_RX);
> +#endif
>   

This kind if unbalanced parenthesis can confuse various tools.  Format
it differently?

    J
