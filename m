Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbYB2SYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbYB2SYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbYB2SYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:24:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYB2SYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:24:43 -0500
Subject: Re: [IA64] fix userspace compile error in gcc_intrin.h
From: David Woodhouse <dwmw2@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Doug Chapman <doug.chapman@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
In-Reply-To: <200802052007.m15K7vuv005319@hera.kernel.org>
References: <200802052007.m15K7vuv005319@hera.kernel.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 13:24:43 -0500
Message-Id: <1204309483.18955.66.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 20:07 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0df29025fd0379d5950d206314d0b10a2c8a9607
> Commit:     0df29025fd0379d5950d206314d0b10a2c8a9607
> Parent:     d2fc0bacd5c438cb459fdf531eff00ab18422a00
> Author:     Doug Chapman <doug.chapman@hp.com>
> AuthorDate: Mon Jan 28 15:33:28 2008 -0800
> Committer:  Tony Luck <tony.luck@intel.com>
> CommitDate: Mon Feb 4 15:08:25 2008 -0800
> 
>     [IA64] fix userspace compile error in gcc_intrin.h
>     
>     Fixes userspace build errors when linux/ipv6.h is included such as in the
>     dhcpv6 package under fedora.  Likely causes other userspace build errors as
>     well.  I found this in akpm's tree from 2.6.18 but could not find any case
>     of anyone proposing it for the main tree.
>     
>     Signed-off-by: Doug Chapman <doug.chapman@hp.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/asm-ia64/gcc_intrin.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-ia64/gcc_intrin.h b/include/asm-ia64/gcc_intrin.h
> index 5b6665c..de2ed2c 100644
> --- a/include/asm-ia64/gcc_intrin.h
> +++ b/include/asm-ia64/gcc_intrin.h
> @@ -24,7 +24,9 @@
>  extern void ia64_bad_param_for_setreg (void);
>  extern void ia64_bad_param_for_getreg (void);
>  
> +#ifdef __KERNEL__
>  register unsigned long ia64_r13 asm ("r13") __used;
> +#endif
>  
>  #define ia64_setreg(regnum, val)						\
>  ({										\

You also want to move gcc_interin.h from $(header-y) to $(unifdef-y) in
include/asm-ia64/Kbuild.

-- 
dwmw2

