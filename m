Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbZJMOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbZJMOH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759903AbZJMOH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:07:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:35662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZJMOH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:07:26 -0400
Date: Tue, 13 Oct 2009 07:07:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
Message-ID: <20091013070722.6e27b25e@infradead.org>
In-Reply-To: <817ecb6f0910130435q56fcbf63r82fae9b94f3eb199@mail.gmail.com>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
	<20091012213229.11898c12@infradead.org>
	<20091013060312.GA3215@elte.hu>
	<817ecb6f0910130435q56fcbf63r82fae9b94f3eb199@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 07:35:28 -0400
Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> ---[ Kernel Mapping ]---
>  0xc0000000-0xc0100000           1M     RW             GLB x  pte
> -0xc0100000-0xc048d000        3636K     ro             GLB x  pte
> -0xc048d000-0xc04d0000         268K     RW             GLB x  pte
> -0xc04d0000-0xc04d2000           8K     RW             GLB NX pte
> -0xc04d2000-0xc04d3000           4K     RW             GLB x  pte
> -0xc04d3000-0xc0531000         376K     RW             GLB NX pte
> -0xc0531000-0xc0600000         828K     RW             GLB x  pte
> +0xc0100000-0xc0381000        2564K     ro             GLB x  pte
> +0xc0381000-0xc048d000        1072K     ro             GLB NX pte
> +0xc048d000-0xc0600000        1484K     RW             GLB NX pte
>  0xc0600000-0xf7800000         882M     RW         PSE GLB NX pmd
>  0xf7800000-0xf79fe000        2040K     RW             GLB NX pte
>  0xf79fe000-0xf7a00000           8K                           pte
> ===============================================
> 

looks great to me; the result is 
* kernel is ro + x
* rodata is ro + NX
* data is RW + NX
(and there is no "RW + x", other than the first megabyte... hmm. maybe
we need to look at that as well at some point)

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
