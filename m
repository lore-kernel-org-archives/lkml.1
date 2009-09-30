Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZI3Vj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZI3Vj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZI3Vj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:39:27 -0400
Received: from [195.41.46.235] ([195.41.46.235]:52562 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbZI3Vj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:39:27 -0400
Date: Wed, 30 Sep 2009 23:39:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Nelson Elhage <nelhage@ksplice.com>
Subject: Re: [PATCH 2/2] arm: Clean up linker script using new linker
	script macros.
Message-ID: <20090930213924.GB15732@merkur.ravnborg.org>
References: <1254345935-15958-1-git-send-email-tabbott@ksplice.com> <1254345935-15958-3-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254345935-15958-3-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 05:25:35PM -0400, Tim Abbott wrote:
> From: Nelson Elhage <nelhage@ksplice.com>
> 
> This patch is mostly a straightforward translation. The primary side
> effect to the resulting vmlinux should be to increase the alignment on
> the initramfs to the standard PAGE_SIZE from 32 bytes.
> 
> Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> ---
>  arch/arm/kernel/vmlinux.lds.S |   75 +++++++++++-----------------------------
>  1 files changed, 21 insertions(+), 54 deletions(-)
> 
>  
> -	.bss : {
> -		__bss_start = .;	/* BSS				*/
> -		*(.bss)
> -		*(COMMON)
> -		__bss_stop = .;
> -		_end = .;

Where is _end in the new layout?
I think we lost it.

> -	}
> -					/* Stabs debugging sections.	*/
> -	.stab 0 : { *(.stab) }
> -	.stabstr 0 : { *(.stabstr) }
> -	.stab.excl 0 : { *(.stab.excl) }
> -	.stab.exclstr 0 : { *(.stab.exclstr) }
> -	.stab.index 0 : { *(.stab.index) }
> -	.stab.indexstr 0 : { *(.stab.indexstr) }
> +	BSS_SECTION(0, 0, 0)
> +	STABS_DEBUG
>  	.comment 0 : { *(.comment) }
>  }

Other than that.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
