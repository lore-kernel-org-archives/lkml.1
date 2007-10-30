Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbXJ3WOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbXJ3WOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXJ3WOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:14:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475AbXJ3WOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:14:09 -0400
Date: Tue, 30 Oct 2007 15:14:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/16] CRIS architecture: Correct compile errors
Message-Id: <20071030151406.9182c9fb.akpm@linux-foundation.org>
In-Reply-To: <20071030093031.GH11960@axis.com>
References: <20071030093031.GH11960@axis.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 10:30:31 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> Include file linux/compiler.h is needed for 'likely'.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> ---
>  atomic.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/include/asm-cris/atomic.h linux-2.6.23/include/asm-cris/atomic.h
> --- clean_linux-2.6.23/include/asm-cris/atomic.h	2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23/include/asm-cris/atomic.h	2007-10-22 10:32:54.000000000 +0200
> @@ -5,6 +5,7 @@
>  
>  #include <asm/system.h>
>  #include <asm/arch/atomic.h>
> +#include <linux/compiler.h>
>  
>  /*
>   * Atomic operations that C can't guarantee us.  Useful for
> /^JN - Jesper Nilsson
> --

We conventionally include the <linux/...> headers before the <asm/...>
headers, with a single blank line between them.  So:

#ifndef __ASM_CRIS_ATOMIC__
#define __ASM_CRIS_ATOMIC__

#include <linux/compiler.h>

#include <asm/system.h>
#include <asm/arch/atomic.h>

/*

