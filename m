Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbXGVFiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbXGVFiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbXGVFiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:38:14 -0400
Received: from web.n-guiza.net ([67.15.10.95]:40257 "EHLO web.n-guiza.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbXGVFiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:38:13 -0400
Date: Mon, 16 Jul 2007 09:45:25 -0300
From: Diego Woitasen <diegows@lanux.org.ar>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Diego Woitasen <diego@woitasen.com.ar>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add KERN_* prefix to printks in bug.h
Message-ID: <20070716124525.GA8062@motherbox.xtechq.com.ar>
References: <11845462192199-git-send-email-diego@woitasen.com.ar> <20070716044547.GA5734@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716044547.GA5734@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - web.n-guiza.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - lanux.org.ar
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 08:45:47AM +0400, Alexey Dobriyan wrote:
> On Sun, Jul 15, 2007 at 09:36:59PM -0300, Diego Woitasen wrote:
> > ---
> >  include/asm-generic/bug.h |   25 +++++++++++++------------
> >  1 files changed, 13 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> > index 7f30cce..6e49266 100644
> > --- a/include/asm-generic/bug.h
> > +++ b/include/asm-generic/bug.h
> > @@ -8,22 +8,23 @@
> >  #ifdef CONFIG_GENERIC_BUG
> >  #ifndef __ASSEMBLY__
> >  struct bug_entry {
> > -	unsigned long	bug_addr;
> > +	unsigned long bug_addr;
> 
> Never include unrelated changes.
> 
> >  #ifdef CONFIG_DEBUG_BUGVERBOSE
> > -	const char	*file;
> > -	unsigned short	line;
> > +	const char *file;
> > +	unsigned short line;
> >  #endif
> > -	unsigned short	flags;
> > +	unsigned short flags;
> >  };
> > -#endif		/* __ASSEMBLY__ */
> > +#endif				/* __ASSEMBLY__ */
> >  
> >  #define BUGFLAG_WARNING	(1<<0)
> > -#endif	/* CONFIG_GENERIC_BUG */
> > +#endif				/* CONFIG_GENERIC_BUG */
> >  
> >  #ifndef HAVE_ARCH_BUG
> > -#define BUG() do { \
> > -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
> > -	panic("BUG!"); \
> > +#define BUG() do { 							\
> > +	printk(KERN_EMERG "BUG: failure at %s:%d/%s()!\n",		\
> > +		__FILE__, __LINE__, __FUNCTION__); 			\
> > +	panic("BUG!"); 							\
> >  } while (0)
> >  #endif
> >  
> > @@ -35,15 +36,15 @@ struct bug_entry {
> >  #define WARN_ON(condition) ({						\
> >  	typeof(condition) __ret_warn_on = (condition);			\
> >  	if (unlikely(__ret_warn_on)) {					\
> > -		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
> > -			__LINE__, __FUNCTION__);			\
> > +		printk(KERN_WARNING "WARNING: at %s:%d %s()\n",		\
> > +			__FILE__, __LINE__, __FUNCTION__);		\
> >  		dump_stack();						\
> >  	}								\
> >  	unlikely(__ret_warn_on);					\
> >  })
> >  #endif
> >  
> > -#else /* !CONFIG_BUG */
> > +#else				/* !CONFIG_BUG */
> >  #ifndef HAVE_ARCH_BUG
> >  #define BUG()
> >  #endif

yes, sorry... the "unrelated" changes are result of Lindent. May be I
should include that in the git log.



-- 

--------------
Diego Woitasen
