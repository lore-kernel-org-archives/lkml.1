Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYG1QK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYG1QK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYG1QKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:10:47 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57614 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYG1QKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:10:47 -0400
Date: Mon, 28 Jul 2008 19:10:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>, Huang Ying <ying.huang@intel.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sh kexec build error
Message-ID: <20080728161004.GH30612@cs181140183.pp.htv.fi>
References: <20080728130613.GB30612@cs181140183.pp.htv.fi> <20080728131444.GA15942@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080728131444.GA15942@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 10:14:44PM +0900, Paul Mundt wrote:
> On Mon, Jul 28, 2008 at 04:06:13PM +0300, Adrian Bunk wrote:
> > Commit 3ab83521378268044a448113c6aa9a9e245f4d2f (kexec jump)
> > causes the following build error on sh:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      kernel/kexec.o
> > {standard input}: Assembler messages:
> > {standard input}:1518: Error: offset to unaligned destination
> > make[2]: *** [kernel/kexec.o] Error 1
> > 
> > <--  snip  -->
> > 
> > If I understand the assembler correctly it fails at
> > include/asm-sh/kexec.h:59
> > 
> Indeed. This should fix it:


I can confirm that your patch fixes the compilation.


> diff --git a/include/asm-sh/processor_32.h b/include/asm-sh/processor_32.h
> index c6583f2..0dadd75 100644
> --- a/include/asm-sh/processor_32.h
> +++ b/include/asm-sh/processor_32.h
> @@ -19,7 +19,7 @@
>   * Default implementation of macro that returns current
>   * instruction pointer ("program counter").
>   */
> -#define current_text_addr() ({ void *pc; __asm__("mova	1f, %0\n1:":"=z" (pc)); pc; })
> +#define current_text_addr() ({ void *pc; __asm__("mova	1f, %0\n.align 2\n1:":"=z" (pc)); pc; })
>  
>  /* Core Processor Version Register */
>  #define CCN_PVR		0xff000030

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

