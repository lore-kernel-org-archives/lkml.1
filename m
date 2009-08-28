Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZH1MLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZH1MLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZH1MLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:11:34 -0400
Received: from ozlabs.org ([203.10.76.45]:54599 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZH1MLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:11:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: modules: Fix build error in the !CONFIG_KALLSYMS case
Date: Fri, 28 Aug 2009 21:41:30 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Helge Deller <deller@gmx.de>
References: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain> <20090828084456.GB3454@elte.hu>
In-Reply-To: <20090828084456.GB3454@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908282141.31175.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 06:14:56 pm Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > James Bottomley (1):
> >       module: workaround duplicate section names
> 
> -tip testing found that this patch breaks the build on x86 if 
> CONFIG_KALLSYMS is disabled:
> 
>  kernel/module.c: In function ‘load_module’:
>  kernel/module.c:2367: error: ‘struct module’ has no member named ‘sect_attrs’
>  distcc[8269] ERROR: compile kernel/module.c on ph/32 failed
>  make[1]: *** [kernel/module.o] Error 1
>  make: *** [kernel] Error 2
>  make: *** Waiting for unfinished jobs....
> 
> Commit 1b364bf misses the fact that section attributes are only 
> built and dealt with if kallsyms is enabled. The patch below fixes 
> this.
> 
> ( note, technically speaking this should depend on CONFIG_SYSFS as
>   well but this patch is correct too and keeps the #ifdef less
>   intrusive - in the KALLSYMS && !SYSFS case the code is a NOP. )
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
