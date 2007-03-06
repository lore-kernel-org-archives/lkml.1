Return-Path: <linux-kernel-owner+w=401wt.eu-S965493AbXCFSSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965493AbXCFSSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXCFSSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:18:03 -0500
Received: from gw.goop.org ([64.81.55.164]:33093 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965505AbXCFSSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:18:01 -0500
Message-ID: <45EDB057.5080106@goop.org>
Date: Tue, 06 Mar 2007 10:17:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 6/8] Allow per-cpu variables to be page-aligned
References: <1173184747.4644.23.camel@localhost.localdomain>	 <1173185592.4644.28.camel@localhost.localdomain>	 <1173185666.4644.30.camel@localhost.localdomain>	 <1173185734.4644.32.camel@localhost.localdomain>	 <1173185827.4644.34.camel@localhost.localdomain>	 <1173185909.4644.36.camel@localhost.localdomain> <1173186021.4644.38.camel@localhost.localdomain>
In-Reply-To: <1173186021.4644.38.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Xen wants page-aligned GDT (and PDA must not cross a page-boundary,
> but that doesn't happen at the moment since it's so close to start of
> page).  Let's allow page-alignment in general for per-cpu data.
>
> Because larger alignments can use more room, we increase the max
> per-cpu memory to 64k rather than 32k: it's getting a little tight.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff -r 213b1ec27001 arch/alpha/kernel/vmlinux.lds.S
> --- a/arch/alpha/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
> +++ b/arch/alpha/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
> @@ -69,7 +69,7 @@ SECTIONS
>    . = ALIGN(8);
>    SECURITY_INIT
>  
> -  . = ALIGN(64);
> +  . = ALIGN(8192);
>   

Isn't there a PAGE_SIZE we can use here?  PAGE_SIZE_asm?
(ditto all archs)

    J
