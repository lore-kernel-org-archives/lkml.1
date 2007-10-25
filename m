Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbXJYQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbXJYQK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXJYQKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:10:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761648AbXJYQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:10:44 -0400
Subject: Re: [PATCH] ia64: check-segrel.lds vs --build-id
From: Doug Chapman <dchapman@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
In-Reply-To: <20071018195453.A34D64D04E2@magilla.localdomain>
References: <20071018195453.A34D64D04E2@magilla.localdomain>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 12:10:38 -0400
Message-Id: <1193328638.7591.10.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-18 at 12:54 -0700, Roland McGrath wrote:
> Some versions of ld with --build-id support will crash when using the flag
> with a linker script that discards notes.  This bites ia64's check-segrel.lds.
> The bug is easy to avoid.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> 
> --- a/arch/ia64/scripts/check-segrel.lds
> +++ b/arch/ia64/scripts/check-segrel.lds
> @@ -1,6 +1,7 @@
>  SECTIONS {
>  	. = SIZEOF_HEADERS;
>  	.rodata : { *(.rodata) } :ro
> +	.note : { *(.note*) }
>  	. = 0xa0000;
>  	.data : { *(.data) } :dat
>  	/DISCARD/ : { *(*) }
> 
> -

This patch is not yet in the git tree.  This, along with the patch to
gate.lds.S that Roland submitted are both blocking our bringup of Fedora
on ia64.

thanks,

- Doug


