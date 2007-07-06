Return-Path: <linux-kernel-owner+w=401wt.eu-S1763678AbXGFSZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763678AbXGFSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbXGFSZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:25:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54800 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbXGFSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:25:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <468E890A.1070504@s5r6.in-berlin.de>
Date: Fri, 06 Jul 2007 20:25:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: Re: [PATCH] I386: Deactivate the test for the dead CONFIG_DEBUG_PAGE_TYPE
 variable.
References: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> diff --git a/arch/i386/kernel/vmi.c b/arch/i386/kernel/vmi.c

Maintainers are apparently those under "PARAVIRT_OPS INTERFACE".
CCs added.

> index c12720d..e3ce5c8 100644
> --- a/arch/i386/kernel/vmi.c
> +++ b/arch/i386/kernel/vmi.c
> @@ -235,7 +235,7 @@ static void vmi_nop(void)
>  {
>  }
> 
> -#ifdef CONFIG_DEBUG_PAGE_TYPE
> +#if 0 /* debug page type */
> 
>  #ifdef CONFIG_X86_PAE
>  #define MAX_BOOT_PTS (2048+4+1)
> @@ -336,7 +336,7 @@ static void vmi_check_page_type(u32 pfn, int type)
>  #else
>  #define vmi_set_page_type(p,t) do { } while (0)
>  #define vmi_check_page_type(p,t) do { } while (0)
> -#endif
> +#endif /* debug page type */
> 
>  #ifdef CONFIG_HIGHPTE
>  static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)

This misnamed CONFIG_DEBUG_PAGE_TYPE (it's not a Kconfig variable) has
about 120 lines debug code dangling on it.  So, replacing it by #if 0
will hopefully motivate a kind janitor to send a removal patch for that
debug code eventually.  I don't do so just now because that code went in
between 2.6.20 and 2.6.21-rc1, i.e. not so long ago.
-- 
Stefan Richter
-=====-=-=== -=== --==-
http://arcgraph.de/sr/
