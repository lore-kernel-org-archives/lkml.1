Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbZJFX2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbZJFX2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933621AbZJFX2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:28:14 -0400
Received: from ozlabs.org ([203.10.76.45]:54318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933610AbZJFX2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:28:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [this_cpu_xx V4 01/20] Introduce this_cpu_ptr() and generic this_cpu_* operations
Date: Tue, 6 Oct 2009 20:34:39 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Tejun Heo <tj@kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <20091001212521.123389189@gentwo.org> <20091002093453.GA21427@elte.hu> <alpine.DEB.1.10.0910021311440.26189@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910021311440.26189@gentwo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062034.40864.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Oct 2009 02:41:54 am Christoph Lameter wrote:
> On Fri, 2 Oct 2009, Ingo Molnar wrote:
> 
> > > @@ -66,6 +69,8 @@ extern void setup_per_cpu_areas(void);
> > >  #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
> > >  #define __get_cpu_var(var)			per_cpu_var(var)
> > >  #define __raw_get_cpu_var(var)			per_cpu_var(var)
> > > +#define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
> > > +#define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)

I still think that it's not symmetrical: get_cpu_var implies get_cpu_ptr; there's no
"this" in any Linux API until now.

OTOH, this_cpu_<op> makes much more sense than cpu_<op> or something, so I'm
not really going to complain.

Does this mean we can kill local.h soon?

Thanks for all this!
Rusty.
