Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbXINWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbXINWOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 18:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbXINWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 18:14:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756612AbXINWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 18:14:09 -0400
Date: Fri, 14 Sep 2007 15:12:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: lethal@linux-sh.org, mikey@neuling.org, jdi@l4x.org, paulus@samba.org,
       torvalds@linux-foundation.org, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, alan@redhat.com,
       heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, dhowells@redhat.com
Subject: Re: Define termios_1 functions for powerpc, s390, avr32 and frv
Message-Id: <20070914151253.d7943119.akpm@linux-foundation.org>
In-Reply-To: <20070914.113324.104043149.davem@davemloft.net>
References: <5058.1189668156@neuling.org>
	<20070913095346.GA28194@linux-sh.org>
	<20070913035506.b599e84f.akpm@linux-foundation.org>
	<20070914.113324.104043149.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 11:33:24 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 13 Sep 2007 03:55:06 -0700
> 
> > I think we need to go with Tony's patch.  sparc32 and sparc64 are
> > presently broken too, and the patch which converts sparc to use the
> > new interfaces introduces a few build errors.
> 
> The problem with the asm-generic/termios.h thing is it only works
> if your copying functions are just a copy_{to,from}_user() and you
> can define that __ARCH_* macro.
> 
> In retrospect what that header should do is, outside of the
> ARCH_* block, define the foo_1 interfaces plainly to foo.
> 
> Alternatively, here is a patch that gets sparc compiling and
> working again in the current tree.
> 
> This whole termios thing hasn't been handled very well, and it's maybe
> not what we should be doing so late in the -rc cycle.  And yes,
> this is coming from the guy who added the TCP oops'er two weeks ago
> :-P

tell me about it.

> [SPARC]: Fix build due to termios changes.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/include/asm-sparc/termios.h b/include/asm-sparc/termios.h
> index d767f20..25e9cbb 100644
> --- a/include/asm-sparc/termios.h
> +++ b/include/asm-sparc/termios.h
> @@ -142,6 +142,11 @@ struct winsize {
>  	0; \
>  })
>  
> +#define user_termios_to_kernel_termios_1(k, u) \
> +	user_termios_to_kernel_termios(k, u)
> +#define kernel_termios_to_user_termios_1(u, k) \
> +	kernel_termios_to_user_termios(u, k)
> +
>  #endif	/* __KERNEL__ */
>  
>  #endif /* _SPARC_TERMIOS_H */
> diff --git a/include/asm-sparc64/termios.h b/include/asm-sparc64/termios.h
> index f05d390..6fc71e6 100644
> --- a/include/asm-sparc64/termios.h
> +++ b/include/asm-sparc64/termios.h
> @@ -145,6 +145,11 @@ struct winsize {
>  	err; \
>  })
>  
> +#define user_termios_to_kernel_termios_1(k, u) \
> +	user_termios_to_kernel_termios(k, u)
> +#define kernel_termios_to_user_termios_1(u, k) \
> +	kernel_termios_to_user_termios(u, k)
> +
>  #endif	/* __KERNEL__ */
>  
>  #endif /* _SPARC64_TERMIOS_H */

That fixes sparc, but I think other architectures are still broken.  And if
we use Tony's ifdef patch to fix the other architectures, that makes the
above sparc-fix patch unneeded.

argh.

