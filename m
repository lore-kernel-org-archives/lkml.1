Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbXGTO0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbXGTO0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764873AbXGTO0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:26:39 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:25475 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764579AbXGTO0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=bVu2v4foL2FFlY+xbPh6sS1csMItN4Bht5MQ0Jgw60ZTf9YQFIZvMQdD1xQwWJA/J8cxz8ciIQjYDs1t+w4sDCd7bRMntbmkm7wDvN8J021tZnyD5zyh+yBdV2fxOhRwKVNRMPd8iLjEbBMZR2ENKGowexEuTWn+xAzmfzHBMgs=
Date: Fri, 20 Jul 2007 16:23:19 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: [PATCH] Use descriptor's functions instead of inline assembly
Message-ID: <20070720142319.GA23448@slug>
References: <1184939761.16311.22.camel@t60>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184939761.16311.22.camel@t60>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:56:01AM -0300, Glauber de Oliveira Costa wrote:
> This patch provides a new set of functions for managing the descriptor
> tables that can be used instead of putting the raw assembly in .c files.
>     
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> -	asm volatile ("str %0"  : "=m" (ctxt->tr));
> +	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
> +	store_idt((struct desc_ptr *)&ctxt->idt_limit);
> +	ctxt->tr = store_tr();
>  
Would'nt a store_tr(&ctxt->tr) be more homogeneous here?

Regards,
Frederik
