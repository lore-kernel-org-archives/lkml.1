Return-Path: <linux-kernel-owner+w=401wt.eu-S934557AbXGKVJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557AbXGKVJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934500AbXGKVJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:09:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934492AbXGKVJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:09:25 -0400
Date: Wed, 11 Jul 2007 14:09:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
Message-Id: <20070711140911.707fcfaa.akpm@linux-foundation.org>
In-Reply-To: <20070711185334.1B8894D0555@magilla.localdomain>
References: <20070711185334.1B8894D0555@magilla.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 11:53:34 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> 
> The assembler for a while now supports -g to generate source line info just
> like the C compiler does.  Source-level assembly debugging sounds like an
> oxymoron, but it is handy to be able to see the right source file and read
> its comments rather than just the disassembly.  This patch enables -g for
> assembly files when CONFIG_DEBUG_INFO=y and the assembler supports the option.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 8a3c271..88b2252 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -498,6 +498,7 @@ endif
>  
>  ifdef CONFIG_DEBUG_INFO
>  CFLAGS		+= -g
> +AFLAGS		+= $(call as-option, -g)
>  endif
>  
>  # Force gcc to behave correct even for buggy distributions

Jason's kgdb tree does

AFLAGS		+= -gdwarf2

(for all architectures!)  Which is better?
