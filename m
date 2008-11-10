Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYKJQx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYKJQx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYKJQxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:53:21 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:35963 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYKJQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:53:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GAwUGQnk8Txg4obc2jgXLQEJElGfaGfY0d2GpETjJrbxmnfYq0svY+5f+GZvWhOuy9
         IZKYwoWZoZ0Sgq55D4CU2RyAIc1+9MZZ37PaUHZeX2IYlnsXW+nBeEBJ+zKWQA9lH/vc
         lLpfySRjpmg/MZmxsXRZJkVpMaQikTAdLKfNo=
Subject: Re: [RFC-PATCH] x86: really use __builtin_memcmp on x86_32
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081110080525.GA13452@elte.hu>
References: <1226297544.5478.26.camel@brick> <20081110074536.GB2093@elte.hu>
	 <20081110080525.GA13452@elte.hu>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 08:53:16 -0800
Message-Id: <1226335996.5478.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 09:05 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> > > Impact: prevent generic code from overriding __builtin_memcmp
> > > 
> > > lib/string.c was using a generic implementation of memcmp
> > > because __HAVE_ARCH_MEMCMP was not defined and it was then doing
> > > #undef memcmp and defining a generic version.
> > > 
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > > ---
> > >  arch/x86/include/asm/string_32.h |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > > +#define __HAVE_ARCH_MEMCMP
> > >  #define memcmp __builtin_memcmp
> > >  
> > >  #define __HAVE_ARCH_MEMCHR
> 
> doesnt work that well:
> 
>  arch/x86/kernel/built-in.o: In function `efi_guidcmp':
>  efi.c:(.text+0x108b2): undefined reference to `memcmp'
>  arch/x86/kernel/built-in.o: In function `smp_check_mpc':
>  mpparse.c:(.init.text+0x4ec6): undefined reference to `memcmp'
>  arch/x86/kernel/built-in.o: In function `powernowk8_cpu_init':
> 
> with the attached config.
> 

Just let this one go to the bitbucket.

Harvey


