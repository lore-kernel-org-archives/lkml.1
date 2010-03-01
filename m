Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0CAPLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:11:53 -0500
Received: from relay2.sgi.com ([192.48.179.30]:38591 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873Ab0CAPLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:11:52 -0500
Date: Mon, 1 Mar 2010 09:11:49 -0600
From: Jack Steiner <steiner@sgi.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic in reserve_memtype()
Message-ID: <20100301151149.GA15134@sgi.com>
References: <20100224202258.GA615@sgi.com> <1267045764.16916.920.camel@localhost.localdomain> <20100224213729.GA15936@sgi.com> <20100224214355.GA16431@linux-os.sc.intel.com> <20100224220518.GA31766@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224220518.GA31766@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 04:05:18PM -0600, Jack Steiner wrote:

> > 
> > I guess I found an obvious problem in the code. Can you check whether the
> > below patch resolves the panic you are seeing.
> > 
> > Thanks,
> > Venki
> 
> 
> Works great!! Thanks...


Venki

Were you planning to push this fix upstream? Both the x86 & linux-next tree
currently fail to boot on EFI-enabled systems because of this bug.

Thanks...


--- jack
> 
> 
> > 
> > 
> > new->type should only change when there is a valid ret_type. Otherwise
> > requested type and return type should be same.
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > ---
> >  arch/x86/mm/pat_rbtree.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
> > index e4cd229..58b6de1 100644
> > --- a/arch/x86/mm/pat_rbtree.c
> > +++ b/arch/x86/mm/pat_rbtree.c
> > @@ -223,7 +223,9 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
> >  						new->type, ret_type);
> >  
> >  	if (!err) {
> > -		new->type = *ret_type;
> > +		if (ret_type)
> > +			new->type = *ret_type;
> > +
> >  		memtype_rb_insert(&memtype_rbroot, new);
> >  	}
> >  	return err;
> > -- 
> > 1.6.0.6
