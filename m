Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbYKGTie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbYKGTie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYKGTi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:38:26 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:51333 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbYKGTiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:38:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAAsiFElMQWxa/2dsb2JhbACBdsd+g1Y
Date: Fri, 7 Nov 2008 14:38:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Eduard Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
Message-ID: <20081107193823.GA32761@Krystal>
References: <1226084321.11596.37.camel@brick> <20081107192029.GA4001@x200.localdomain> <1226085759.11596.43.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1226085759.11596.43.camel@brick>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:35:59 up 156 days, 16 min,  6 users,  load average: 0.73,
	1.76, 1.46
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Harvey Harrison (harvey.harrison@gmail.com) wrote:
> On Fri, 2008-11-07 at 22:20 +0300, Alexey Dobriyan wrote:
> > On Fri, Nov 07, 2008 at 10:58:41AM -0800, Harvey Harrison wrote:
> > > --- a/include/linux/kmemtrace.h
> > > +++ b/include/linux/kmemtrace.h
> > > @@ -34,7 +34,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
> > >  		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
> > >  		   type_id, call_site, (unsigned long) ptr,
> > >  		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
> > > -		   (unsigned long) gfp_flags, node);
> > > +		   (__force unsigned long)gfp_flags, node);
> > 
> > gfp_t is "unsigned int" actually. These casts are bogus.
> > 
> > Subject: How do I printk <type> correctly?
> > 
> > If variable is of Type	use	printk format specifier.
> > ---------------------------------------------------------
> > 		int			%d or %x
> > 		unsigned int		%u or %x
> > 		long			%ld ot %lx
> > 		unsigned long		%lu or %lx
> > 		long long		%lld or %llx
> > 		unsigned long long	%llu or %llx
> > 		size_t			%zu or %zx
> > 		ssize_t			%zd or %zx
> > 
> 
> Perhaps add gfp_t to the list ;-)
> 

I think a cast

(__force unsigned) could be required for checker ?

#ifdef __CHECKER__
#define __bitwise__ __attribute__((bitwise))
#else
#define __bitwise__
#endif

typedef unsigned __bitwise__ gfp_t;

OTOH, adding a

%uB to printk so it supports bitwise variables may not hurt...

Mathieu

> Thanks.
> 
> Harvey
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
