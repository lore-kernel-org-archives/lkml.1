Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbXJOVYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbXJOVYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbXJOVYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:24:10 -0400
Received: from mail.suse.de ([195.135.220.2]:43543 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbXJOVYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:24:09 -0400
Date: Mon, 15 Oct 2007 23:24:06 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, ak@suse.de
Subject: Re: [patch 1/2] Add BSS to resource tree
Message-ID: <20071015212406.GA17804@suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, ak@suse.de
References: <20071015115042.391348549@strauss.suse.de> <20071015115042.958614570@strauss.suse.de> <20071015113206.36c06361.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015113206.36c06361.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2007-10-15 20:32]:
> On Mon, 15 Oct 2007 13:50:43 +0200
> Bernhard Walle <bwalle@suse.de> wrote:
> 
> > --- a/arch/x86/kernel/e820_32.c
> > +++ b/arch/x86/kernel/e820_32.c
> > @@ -51,6 +51,13 @@ struct resource code_resource = {
> >  	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
> >  };
> >  
> > +struct resource bss_resource = {
> > +	.name	= "Kernel bss",
> > +	.start	= 0,
> > +	.end	= 0,
> > +	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
> > +};
> > +
> >  static struct resource system_rom_resource = {
> >  	.name	= "System ROM",
> >  	.start	= 0xf0000,
> > @@ -287,6 +294,7 @@ legacy_init_iomem_resources(struct resou
> >  			 */
> >  			request_resource(res, code_resource);
> >  			request_resource(res, data_resource);
> > +			request_resource(res, &bss_resource);
> 
> Looks ungainly, doesn't it?  Perhaps we should add a third arg to
> legacy_init_iomem_resources(), or change legacy_init_iomem_resources() to
> take zero args?  

Yes. But when we change legacy_init_iomem_resources(), then we should
also change efi_initialize_iomem_resources(). But that's declared in
<linux/efi.h> and so a change in ia64 code is required which I wanted
to avoid.

But that patch is for review of the idea. If nobody has objections,
then I'll implement the IA64 change anyway -- and then the 3rd
parameter can be added.


Thanks,
   Bernhard
