Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYINVn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYINVn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 17:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYINVnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 17:43:18 -0400
Received: from nocturne.unbit.it ([81.174.68.18]:40943 "EHLO smtp.unbit.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626AbYINVnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 17:43:18 -0400
Subject: Re: [PATCH] xen: Fix for xen guest with mem > 3.7G
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, jeremy@xensource.com,
       linux-kernel@vger.kernel.org, Mirko Iannella <mirko@unbit.it>,
       Alex Nixon <alex.nixon@citrix.com>
In-Reply-To: <48CD22CF.9030900@goop.org>
References: <1221333418.6036.9.camel@sirius> <48CC2C12.4080302@goop.org>
	 <20080914132104.GB32106@elte.hu>  <48CD22CF.9030900@goop.org>
Content-Type: text/plain
Organization: Unbit
Date: Sun, 14 Sep 2008 23:43:13 +0200
Message-Id: <1221428593.6036.15.camel@sirius>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-14 at 07:42 -0700, Jeremy Fitzhardinge wrote:
> PFN_PHYS() can truncate large addresses unless its passed a suitable
> large type.  This is fixed more generally in the patch series
> introducing phys_addr_t, but we need a short-term fix to solve a
> regression.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: roberto@unbit.it
> ---
>  arch/x86/xen/setup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> ===================================================================
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -42,7 +42,7 @@
>  
>  	e820.nr_map = 0;
>  
> -	e820_add_region(0, PFN_PHYS(max_pfn), E820_RAM);
> +	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
>  
>  	/*
>  	 * Even though this is normal, usable memory under Xen, reserve


In this way you pass a 64bit integer to the function, but max_pfn in
origin is still 32bit.

max_pfn need to be 64bit to supporto more than 4GB

> 
> 
-- 
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it

