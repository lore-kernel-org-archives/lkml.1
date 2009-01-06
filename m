Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbZAFADa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbZAFADa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZAFADV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:03:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbZAFADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:03:20 -0500
Date: Mon, 5 Jan 2009 16:03:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
Message-Id: <20090105160306.6b710828.akpm@linux-foundation.org>
In-Reply-To: <20090104233640.6A7453E6653@basil.firstfloor.org>
References: <200901051236.281008835@firstfloor.org>
	<20090104233640.6A7453E6653@basil.firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Jan 2009 00:36:40 +0100 (CET)
Andi Kleen <andi@firstfloor.org> wrote:

> Hugh Dickins noticed that older gcc versions when the kernel
> is built for code size didn't inline some of the bitops.
> 
> Mark all complex x86 bitops that have more than a single
> asm statement or two as always inline to avoid this problem.
> 
> Probably should be done for other architectures too.
> 

Well yes.  This is why we did

#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
    !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
# define inline		inline		__attribute__((always_inline))
# define __inline__	__inline__	__attribute__((always_inline))
# define __inline	__inline	__attribute__((always_inline))
#endif

but people had to go and futz with it, make it complicated and break
stuff.  Sigh.

