Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbYA2RqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbYA2RqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYA2RqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:46:08 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45469 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYA2RqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:46:06 -0500
Date: Tue, 29 Jan 2008 10:03:14 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: fix overlap between pagetable with bss section
In-reply-to: <20080129174242.GA26562@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <200801291003.14741.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801281844.36940.yinghai.lu@sun.com>
 <20080129174242.GA26562@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 09:42:43 am Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > [PATCH] x86_64: fix overlap between pagetable with bss section
> > 
> > one early crash on one 8 node 256g machine
> 
> > +++ b/arch/x86/mm/init_64.c
> > @@ -358,6 +358,8 @@ static void __init find_early_table_space(unsigned long end)
> >  	if (table_start == -1UL)
> >  		panic("Cannot find space for the kernel page tables");
> >  
> > +	/* need to round it up to avoid overlap less one page */
> > +	table_start = round_up(table_start, PAGE_SIZE);
> >  	table_start >>= PAGE_SHIFT;
> >  	table_end = table_start;
> 
> thanks, applied.
> 
> 	Ingo
> 

can you use v2 instead? v2 have more comments.

Thanks

Yinghai Lu
