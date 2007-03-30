Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXC3Cq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXC3Cq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 22:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbXC3Cq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 22:46:58 -0400
Received: from waste.org ([66.93.16.53]:53829 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932954AbXC3Cq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 22:46:57 -0400
Date: Thu, 29 Mar 2007 21:33:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org, bunk@stusta.de,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Cleanup: i386 separate hardware-defined TSS from Linux additions
Message-ID: <20070330023355.GU10459@waste.org>
References: <200703270607.l2R672de009090@shell0.pdx.osdl.net> <200703291219.47276.ak@suse.de> <1175165905.12230.201.camel@localhost.localdomain> <200703291316.56393.ak@suse.de> <1175222195.12230.363.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175222195.12230.363.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 12:36:35PM +1000, Rusty Russell wrote:
> On Thu, 2007-03-29 at 13:16 +0200, Andi Kleen wrote:
> > Please clean it up properly with two structs.
> 
> Not sure about this, now I've done it.  Running it here.
> 
> If you like it, I can do x86-64 as well.
> 
> ==
> lguest defines its own TSS struct because the "struct tss_struct"
> contains linux-specific additions.  Andi asked me to split the struct
> in processor.h.
> 
> Unfortunately it makes usage a little awkward.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r 7edfac26a523 include/asm-i386/processor.h
> --- a/include/asm-i386/processor.h	Thu Mar 29 20:02:17 2007 +1000
> +++ b/include/asm-i386/processor.h	Fri Mar 30 12:22:38 2007 +1000
> @@ -325,7 +325,8 @@ typedef struct {
>  
>  struct thread_struct;
>  
> -struct tss_struct {
> +/* This is the TSS defined by the hardware. */
> +struct i386_hw_tss {
>  	unsigned short	back_link,__blh;
>  	unsigned long	esp0;
>  	unsigned short	ss0,__ss0h;
> @@ -349,6 +350,11 @@ struct tss_struct {
>  	unsigned short	gs, __gsh;
>  	unsigned short	ldt, __ldth;
>  	unsigned short	trace, io_bitmap_base;
> +} __attribute__((packed));
> +
> +struct tss_struct {
> +	struct i386_hw_tss x86_tss;
> +
>  	/*
>  	 * The extra 1 is there because the CPU will access an
>  	 * additional byte beyond the end of the IO permission

This comment needs to stay in the first struct..?

-- 
Mathematics is the supreme nostalgia of our time.
