Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZINVgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZINVgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbZINVgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:36:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932275AbZINVgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:36:21 -0400
Date: Mon, 14 Sep 2009 14:36:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH] [5/5] kbuild: Set -fconserve-stack option for gcc 4.5
Message-Id: <20090914143615.9ee47a1a.akpm@linux-foundation.org>
In-Reply-To: <20090914201811.187B3B1757@basil.firstfloor.org>
References: <200909141018.915641783@firstfloor.org>
	<20090914201811.187B3B1757@basil.firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 22:18:11 +0200 (CEST)
Andi Kleen <andi@firstfloor.org> wrote:

> 
> The upcomming gcc 4.5 has a new -fconserve-stack option 
> that tells the inliner to take stack frame size in account.
> Set it if the compiler supports it.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  Makefile |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.31-rc3-ak/Makefile
> ===================================================================
> --- linux-2.6.31-rc3-ak.orig/Makefile
> +++ linux-2.6.31-rc3-ak/Makefile
> @@ -575,6 +575,9 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-s
>  # revert to pre-gcc-4.4 behaviour of .eh_frame
>  KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
>  
> +# conserve stack if available
> +KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)

Do we have any info about what effects this option has upon the
generated code?  Text size changes, runtime stack usage changes, etc?

