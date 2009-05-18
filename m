Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZEREYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZEREYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 00:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZEREYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 00:24:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:33034 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZEREYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 00:24:04 -0400
Subject: Re: [PATCH 5/8] powerpc: use new macro for .data.cacheline_aligned
 section.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <1241135777-9462-6-git-send-email-tabbott@mit.edu>
References: <1241135777-9462-1-git-send-email-tabbott@mit.edu>
	 <1241135777-9462-2-git-send-email-tabbott@mit.edu>
	 <1241135777-9462-3-git-send-email-tabbott@mit.edu>
	 <1241135777-9462-4-git-send-email-tabbott@mit.edu>
	 <1241135777-9462-5-git-send-email-tabbott@mit.edu>
	 <1241135777-9462-6-git-send-email-tabbott@mit.edu>
Content-Type: text/plain
Date: Mon, 18 May 2009 14:23:38 +1000
Message-Id: <1242620618.18075.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 19:56 -0400, Tim Abbott wrote:
> .data.cacheline_aligned should not need a separate output section;
> this change moves it into the .data section.
> 
> Since there isn't an ALIGN() directive before the
> .data.cacheline_aligned scetion in the current linker script, I'd like
> an ack from one of the powerpc maintainers that L1_CACHE_BYTES is the
> correct alignment here.

Yes, that's the right size.

Also. that looks like a bug to me in the current stuff. I'm queuing your
patch set for .31 but I'll stick a "fix" in .30 for that just in case
which unfortunately means your patches will probably need to be rebased.

Cheers,
Ben.

> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@ozlabs.org
> ---
>  arch/powerpc/kernel/vmlinux.lds.S |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
> index 4223892..e769717 100644
> --- a/arch/powerpc/kernel/vmlinux.lds.S
> +++ b/arch/powerpc/kernel/vmlinux.lds.S
> @@ -223,6 +223,7 @@ SECTIONS
>  	.data : AT(ADDR(.data) - LOAD_OFFSET) {
>  		PAGE_ALIGNED_DATA
>  		NOSAVE_DATA
> +		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
>  		DATA_DATA
>  #ifdef CONFIG_PPC32
>  		*(.sdata)
> @@ -260,10 +261,6 @@ SECTIONS
>  		*(.data.init_task)
>  	}
>  
> -	.data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
> -		*(.data.cacheline_aligned)
> -	}
> -
>  	. = ALIGN(L1_CACHE_BYTES);
>  	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
>  		*(.data.read_mostly)

