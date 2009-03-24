Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZCXNCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZCXNCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZCXNCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:02:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:56182 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZCXNCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rDPeNh/ht/AMmVy+USiNmIYUlG9zPxLr+mXCZG9WtpShN0ax6c24DpyAuiotX0LdOQ
         jUb9tQ734nSRDzAFx6YY7biRKbZ3916LOFjIlDz91ed99lQ8w61SfRGgn62TSxtJbR9v
         ehfFeHt1TShyVsuJqUyOYoI54bwS6Fz+lyUyI=
Date: Tue, 24 Mar 2009 16:09:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, eduard.munteanu@linux360.ro,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
Message-ID: <20090324130926.GA11358@x200.localdomain>
References: <1237884846.25315.37.camel@penberg-laptop> <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop> <20090324090757.GH13016@elte.hu> <1237886113.25315.49.camel@penberg-laptop> <20090324091742.GB6605@elte.hu> <1237886559.25315.60.camel@penberg-laptop> <20090324093103.GA19463@elte.hu> <1237887513.25315.65.camel@penberg-laptop> <20090324095346.GB23208@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324095346.GB23208@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:53:46AM +0100, Ingo Molnar wrote:
> > -static inline char *alloc_secdata(void)
> > -{
> > -       return (char *)get_zeroed_page(GFP_KERNEL);
> > -}
> > -
> > -static inline void free_secdata(void *secdata)
> > -{
> > -       free_page((unsigned long)secdata);
> > -}
> > +#define alloc_secdata() (char *)get_zeroed_page(GFP_KERNEL)
> > +#define free_secdata()  free_page((unsigned long) secdata)
> 
> yep, that would be fine - but please add a comment about why they 
> are macros and what would have to be done to fix it.

Nooo!

Stick it into security.h!

> (the real fix would be to separate fs.h into fs_types.h and 
> fs_apis.h - like we did it with spinlock.h. Similarly with slab.h.)
