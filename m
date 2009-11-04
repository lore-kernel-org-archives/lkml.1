Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZKDTJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZKDTJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZKDTJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:09:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbZKDTJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:09:27 -0500
Date: Wed, 4 Nov 2009 21:05:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
       s.hetze@linux-ag.com
Subject: Re: [PATCHv6 1/3] tun: export underlying socket
Message-ID: <20091104190523.GA772@redhat.com>
References: <cover.1257193660.git.mst@redhat.com> <20091102222612.GB15184@redhat.com> <200911031312.33580.arnd@arndb.de> <200911041909.06054.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911041909.06054.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 07:09:05PM +0100, Arnd Bergmann wrote:
> On Tuesday 03 November 2009, Arnd Bergmann wrote:
> > > index 3f5fd52..404abe0 100644
> > > --- a/include/linux/if_tun.h
> > > +++ b/include/linux/if_tun.h
> > > @@ -86,4 +86,18 @@ struct tun_filter {
> > >         __u8   addr[0][ETH_ALEN];
> > >  };
> > >  
> > > +#ifdef __KERNEL__
> > > +#if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
> > > +struct socket *tun_get_socket(struct file *);
> > > +#else
> > > +#include <linux/err.h>
> > > +#include <linux/errno.h>
> > > +struct file;
> > > +struct socket;
> > > +static inline struct socket *tun_get_socket(struct file *f)
> > > +{
> > > +       return ERR_PTR(-EINVAL);
> > > +}
> > > +#endif /* CONFIG_TUN */
> > > +#endif /* __KERNEL__ */
> > >  #endif /* __IF_TUN_H */
> > 
> > Is this a leftover from testing? Exporting the function for !__KERNEL__
> > seems pointless.
> > 
> 
> Michael, you didn't reply on this comment and the code is still there in v8.
> Do you actually need this? What for?
> 
> 	Arnd <><

Sorry, missed the question. If you look closely it is not exported for
!__KERNEL__ at all.  The stub is for when CONFIG_TUN is undefined.
Maybe I'll add a comment near #else, even though this is a bit strange
since the #if is just 2 lines above it.

-- 
MST
