Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbZJMEce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbZJMEce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZJMEcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:32:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:34717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZJMEcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:32:32 -0400
Date: Mon, 12 Oct 2009 21:32:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
Message-ID: <20091012213229.11898c12@infradead.org>
In-Reply-To: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
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

On Mon, 12 Oct 2009 21:03:17 -0400
Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
> (static) kernel data area as NX.
> The following steps are taken to achieve this:
> 1. Linker script is adjusted so .text always starts and ends on a
> page boundary 2. Linker script is adjusted so .rodata and .data
> always start and end on a page boundary
> 3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
> functionality: NX is set for all pages from _etext through _end.
> 4. mark_nxdata_nx() called from free_initmem() (after init has been
> released) 5. free_init_pages() sets released memory NX in
> arch/x86/mm/init.c
> 
> The patch have been developed for Linux 2.6.31-rc7 x86 by Siarhei
> Liakh <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
> 

I like doing this, but... maybe it is useful to have a diff of the
pagetable dump (PT_DUMP config option) to show the effect, in the
changelog. That'd be like the proof on the pudding...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
