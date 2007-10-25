Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbXJYQIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbXJYQIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXJYQIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:08:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXJYQIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:08:21 -0400
Subject: Re: [PATCH] ia64 vDSO vs --build-id
From: Doug Chapman <dchapman@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
In-Reply-To: <20071018221108.638644D04E2@magilla.localdomain>
References: <20071018221108.638644D04E2@magilla.localdomain>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 12:08:12 -0400
Message-Id: <1193328492.7591.6.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-18 at 15:11 -0700, Roland McGrath wrote:
> When gcc uses --build-id by default, the gate.lds.S linker script runs afoul
> of the new note section and produces a bad DSO image.  This fixes it.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> 
> --- a/arch/ia64/kernel/gate.lds.S
> +++ b/arch/ia64/kernel/gate.lds.S
> @@ -20,6 +20,8 @@ SECTIONS
>  	.gnu.version_d		: { *(.gnu.version_d) }
>  	.gnu.version_r		: { *(.gnu.version_r) }
>  
> +	.note			: { *(.note*) }		:readable	:note
> +
>  	.dynamic		: { *(.dynamic) }	:readable	:dynamic
>  
>  	/*
> @@ -83,6 +85,7 @@ PHDRS
>  	epc		PT_LOAD	FILEHDR PHDRS	FLAGS(1);	/* PF_X */
>  #endif
>  	dynamic		PT_DYNAMIC		FLAGS(4);	/* PF_R */
> +	note		PT_NOTE			FLAGS(4);	/* PF_R */
>  	unwind		PT_IA_64_UNWIND;
>  }
>  
> -

Any news on this?  It does not appear to have been commited to git.
This issue is blocking our bringup of Fedora on ia64.  The Fedora gcc
uses the --build-id option by default leading to a hang during bootup
without this patch.

thanks,

- Doug


