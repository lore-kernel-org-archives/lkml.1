Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbZKDSJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbZKDSJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbZKDSJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:09:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZKDSJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:09:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv6 1/3] tun: export underlying socket
Date: Wed, 4 Nov 2009 19:09:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
       s.hetze@linux-ag.com
References: <cover.1257193660.git.mst@redhat.com> <20091102222612.GB15184@redhat.com> <200911031312.33580.arnd@arndb.de>
In-Reply-To: <200911031312.33580.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041909.06054.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18DCdzuXdL2vqnnzAm9II9OrjKyCnZiQDWJz/Y
 kPC9xcJVenQn4SnpExDFrBEgW5Gt51fy4+wwrYdyblva2P0yyx
 IH3sUHin6zejNXj4GmuEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009, Arnd Bergmann wrote:
> > index 3f5fd52..404abe0 100644
> > --- a/include/linux/if_tun.h
> > +++ b/include/linux/if_tun.h
> > @@ -86,4 +86,18 @@ struct tun_filter {
> >         __u8   addr[0][ETH_ALEN];
> >  };
> >  
> > +#ifdef __KERNEL__
> > +#if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
> > +struct socket *tun_get_socket(struct file *);
> > +#else
> > +#include <linux/err.h>
> > +#include <linux/errno.h>
> > +struct file;
> > +struct socket;
> > +static inline struct socket *tun_get_socket(struct file *f)
> > +{
> > +       return ERR_PTR(-EINVAL);
> > +}
> > +#endif /* CONFIG_TUN */
> > +#endif /* __KERNEL__ */
> >  #endif /* __IF_TUN_H */
> 
> Is this a leftover from testing? Exporting the function for !__KERNEL__
> seems pointless.
> 

Michael, you didn't reply on this comment and the code is still there in v8.
Do you actually need this? What for?

	Arnd <><
