Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYGKAi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYGKAi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbYGKAiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:38:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755018AbYGKAiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:38:51 -0400
Date: Thu, 10 Jul 2008 17:32:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [PATCH] Intel IOMMU: RMRRs do not necessarily have to be
 present on all VT-d capable platforms
Message-Id: <20080710173243.3de505c7.akpm@linux-foundation.org>
In-Reply-To: <20080710235326.GA21208@ywang-dev>
References: <20080701091354.GA12969@ywang-dev>
	<20080710010149.a73d779c.akpm@linux-foundation.org>
	<20080710235326.GA21208@ywang-dev>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 19:53:26 -0400 Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Thu, Jul 10, 2008 at 01:01:49AM -0700, Andrew Morton wrote:
> > On Tue, 1 Jul 2008 05:13:54 -0400 Yong Wang <yong.y.wang@linux.intel.com> wrote:
> > 
> > > RMRRs do not necessarily have to be present on all VT-d capable platforms.
> > > The printk is just informational and does not need to be followed by an
> > > error return.
> > > 
> > > Signed-off-by: Yong Y Wang <yong.y.wang@intel.com>
> > > ---
> > >  dmar.c |    4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> > > index f941f60..8bf86ae 100644
> > > --- a/drivers/pci/dmar.c
> > > +++ b/drivers/pci/dmar.c
> > > @@ -317,10 +317,8 @@ int __init dmar_table_init(void)
> > >  		return -ENODEV;
> > >  	}
> > >  
> > > -	if (list_empty(&dmar_rmrr_units)) {
> > > +	if (list_empty(&dmar_rmrr_units))
> > >  		printk(KERN_INFO PREFIX "No RMRR found\n");
> > > -		return -ENODEV;
> > > -	}
> > >  
> > >  	return 0;
> > >  }
> > 
> > >From your description I am unable to work out how important this fix is.
> > 
> > Is it needed in 2.6.25.x?  In 2.6.26?  In 2.6.27?  There's no way for me to
> > know :(
> 
> Actually this is the same as Suresh' x2apic patch 05/26. The absence of RMRRs
> will prevent kernel from parsing IOxAPICs without this patch and thus leaves
> IOxAPICs in an uninitialized state.

And what runtime effect does that have?
