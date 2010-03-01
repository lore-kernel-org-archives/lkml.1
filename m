Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab0CARzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:55:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:27302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0CARzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:55:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,561,1262592000"; 
   d="scan'208";a="496695869"
Subject: Re: Panic in reserve_memtype()
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Jack Steiner <steiner@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20100301151149.GA15134@sgi.com>
References: <20100224202258.GA615@sgi.com>
	 <1267045764.16916.920.camel@localhost.localdomain>
	 <20100224213729.GA15936@sgi.com>
	 <20100224214355.GA16431@linux-os.sc.intel.com>
	 <20100224220518.GA31766@sgi.com>  <20100301151149.GA15134@sgi.com>
Content-Type: text/plain
Date: Mon, 01 Mar 2010 09:55:04 -0800
Message-Id: <1267466104.16916.925.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding Peter.

Can you push this patch along.

Thanks
Venki

On Mon, 2010-03-01 at 07:11 -0800, Jack Steiner wrote:
> On Wed, Feb 24, 2010 at 04:05:18PM -0600, Jack Steiner wrote:
> 
> > > 
> > > I guess I found an obvious problem in the code. Can you check whether the
> > > below patch resolves the panic you are seeing.
> > > 
> > > Thanks,
> > > Venki
> > 
> > 
> > Works great!! Thanks...
> 
> 
> Venki
> 
> Were you planning to push this fix upstream? Both the x86 & linux-next tree
> currently fail to boot on EFI-enabled systems because of this bug.
> 
> Thanks...
> 
> 
> --- jack
> > 
> > 
> > > 
> > > 
> > > new->type should only change when there is a valid ret_type. Otherwise
> > > requested type and return type should be same.
> > > 
> > > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > > ---
> > >  arch/x86/mm/pat_rbtree.c |    4 +++-
> > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
> > > index e4cd229..58b6de1 100644
> > > --- a/arch/x86/mm/pat_rbtree.c
> > > +++ b/arch/x86/mm/pat_rbtree.c
> > > @@ -223,7 +223,9 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
> > >  						new->type, ret_type);
> > >  
> > >  	if (!err) {
> > > -		new->type = *ret_type;
> > > +		if (ret_type)
> > > +			new->type = *ret_type;
> > > +
> > >  		memtype_rb_insert(&memtype_rbroot, new);
> > >  	}
> > >  	return err;
> > > -- 
> > > 1.6.0.6


