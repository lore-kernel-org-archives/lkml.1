Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbXJOSce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbXJOSce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXJOScZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:32:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756010AbXJOScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:32:24 -0400
Date: Mon, 15 Oct 2007 11:32:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, ak@suse.de
Subject: Re: [patch 1/2] Add BSS to resource tree
Message-Id: <20071015113206.36c06361.akpm@linux-foundation.org>
In-Reply-To: <20071015115042.958614570@strauss.suse.de>
References: <20071015115042.391348549@strauss.suse.de>
	<20071015115042.958614570@strauss.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 13:50:43 +0200
Bernhard Walle <bwalle@suse.de> wrote:

> --- a/arch/x86/kernel/e820_32.c
> +++ b/arch/x86/kernel/e820_32.c
> @@ -51,6 +51,13 @@ struct resource code_resource = {
>  	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
>  };
>  
> +struct resource bss_resource = {
> +	.name	= "Kernel bss",
> +	.start	= 0,
> +	.end	= 0,
> +	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
> +};
> +
>  static struct resource system_rom_resource = {
>  	.name	= "System ROM",
>  	.start	= 0xf0000,
> @@ -287,6 +294,7 @@ legacy_init_iomem_resources(struct resou
>  			 */
>  			request_resource(res, code_resource);
>  			request_resource(res, data_resource);
> +			request_resource(res, &bss_resource);

Looks ungainly, doesn't it?  Perhaps we should add a third arg to
legacy_init_iomem_resources(), or change legacy_init_iomem_resources() to
take zero args?  
