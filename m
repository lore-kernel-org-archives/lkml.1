Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbZD0Ssa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbZD0Ssa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbZD0SsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:48:19 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35122 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810AbZD0SsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:48:18 -0400
Date: Mon, 27 Apr 2009 20:50:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 7/8] sparc: cleanup references to deprecated .text.init* sections.
Message-ID: <20090427185027.GG12056@uranus.ravnborg.org>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu> <1240855347-19316-3-git-send-email-tabbott@mit.edu> <1240855347-19316-4-git-send-email-tabbott@mit.edu> <1240855347-19316-5-git-send-email-tabbott@mit.edu> <1240855347-19316-6-git-send-email-tabbott@mit.edu> <1240855347-19316-7-git-send-email-tabbott@mit.edu> <1240855347-19316-8-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240855347-19316-8-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:02:26PM -0400, Tim Abbott wrote:
> The section .text.init.refok is deprecated and __REF (.ref.text)
> should be used in assembly files instead.  This patch cleans up a few
> uses of .text.init.refok in the sparc architecture.
> 
> Also fix a reference to .text.init in a comment that wasn't updated to
> .init.text.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: David S. Miller <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  arch/sparc/kernel/head_32.S |    2 +-
>  arch/sparc/kernel/head_64.S |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/sparc/kernel/head_32.S b/arch/sparc/kernel/head_32.S
> index e91f01a..6b4d8ac 100644
> --- a/arch/sparc/kernel/head_32.S
> +++ b/arch/sparc/kernel/head_32.S
> @@ -735,7 +735,7 @@ go_to_highmem:
>  		 nop
>  
>  /* The code above should be at beginning and we have to take care about
> - * short jumps, as branching to .text.init section from .text is usually
> + * short jumps, as branching to .init.text section from .text is usually
>   * impossible */
>  		__INIT
>  /* Acquire boot time privileged register values, this will help debugging.
> diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
> index 3a1b7bf..91bf4c7 100644
> --- a/arch/sparc/kernel/head_64.S
> +++ b/arch/sparc/kernel/head_64.S
> @@ -467,7 +467,7 @@ jump_to_sun4u_init:
>  	jmpl    %g2 + %g0, %g0
>  	 nop
>  
> -	.section	.text.init.refok
> +	__REF
>  sun4u_init:
>  	BRANCH_IF_SUN4V(g1, sun4v_init)
>  
> -- 
> 1.6.2.1
> 
