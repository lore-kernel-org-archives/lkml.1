Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbXBRVdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbXBRVdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 16:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXBRVdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 16:33:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbXBRVdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 16:33:54 -0500
Message-ID: <45D8C620.2000009@redhat.com>
Date: Sun, 18 Feb 2007 16:33:20 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mtrr range check correction
References: <45D2CBEF.76E4.0078.0@novell.com>
In-Reply-To: <45D2CBEF.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Whether a region is below 1Mb is determined by its start rather than
> its end.
> 
> This hunk got erroneously dropped from a previous patch.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> --- linux-2.6.20/arch/i386/kernel/cpu/mtrr/generic.c	2007-02-04 19:44:54.000000000 +0100
> +++ 2.6.20-x86-mtrr-range-check/arch/i386/kernel/cpu/mtrr/generic.c	2007-02-09 10:17:26.000000000 +0100
> @@ -428,7 +428,7 @@ int generic_validate_add_page(unsigned l
>  		}
>  	}
>  
> -	if (base + size < 0x100) {
> +	if (base < 0x100) {
>  		printk(KERN_WARNING "mtrr: cannot set region below 1 MiB (0x%lx000,0x%lx000)\n",
>  		       base, size);
>  		return -EINVAL;
> 

What about wraparound?

