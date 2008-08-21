Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYHUQht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYHUQht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYHUQhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:37:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025AbYHUQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:37:41 -0400
Date: Thu, 21 Aug 2008 09:36:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <JosephChan@via.com.tw>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <geert@linux-m68k.org>
Subject: Re: [PATCH 3/13 v2] viafb: accel.c, accel.h
Message-Id: <20080821093654.4947f140.akpm@linux-foundation.org>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8285FDD@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698F@exchtp03.taipei.via.com.tw>
	<20080819162303.5fc89c63.akpm@linux-foundation.org>
	<C80EF34A3D2E494DBAF9AC29C7AE4EB8285FDD@exchtp03.taipei.via.com.tw>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 22:30:57 +0800 <JosephChan@via.com.tw> wrote:

> Hi Andrew,
>  
> It's our carelessness to check with x86_64 version. And thanks for reminding this.
> The 
>  
>  
> >due to things like this:
> >
> >        MMIO_OUT32(VIA_REG_DSTBASE,
> >                   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
> >
> >now, we could just shut the warnings up by casting to (long) instead.
> 
> >But I wonder what's going on in there.  ->screen_base came from
> >ioremap_nocache() and AFAIK there's no guarantee that this virtual
> >address will be less than 4G on 64-bit machines?
> 
> 
> >If the !VIA_MMIO code has no valid use then please just remove it.
> >
> >The VIA_MMIO!=0 macros inplicitly reference a local variable which is
> >the kind of dopey programming trick which should not be performed in
> >new code.  It would be much better to do
> >
> >static inline void via_writel(struct viafb_par *viaparinfo, int reg, u32 val)
> >{
> >        writel(val, viaparinfo->io_virt + reg);
> >}
> >
> >and use that everywhere.
> >
> >It would also be quite acceptable to simply open-code the
> >
> >        writel(val, viaparinfo->io_virt + reg);
> >
> >at all callsites.
> >
> >Those macros may have made it easier to _write_ the code, but they make
> >it harder to _read_ it.  That's a wrong tradeoff.
> 
> Yes, the code seems to be cleaner after removing the macro. 
> We define this macro for convenient debugging originally 
> (MMIO couldn't work due to some wired reason, we can 
> transfer to PORT easily by changing VIA_MMIO=0). 
> It is a real tradeoff.

ok.

> If necessary, we could modify this patch by following your
> suggestions. 
> Should we do that? or they're already done by you?

An incremental patch against the previous patches would be best, please.
