Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYACXZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYACXZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYACXZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:25:18 -0500
Received: from smtp.knology.net ([24.214.63.101]:43719 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYACXZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:25:17 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 18:25:17 EST
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
From: Dave Dillow <dillowda@ornl.gov>
To: Rik van Riel <riel@redhat.com>
Cc: Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080103181127.054dd917@cuia.boston.redhat.com>
References: <adak5mqu5i8.fsf@cisco.com>
	 <1199385590.7561.11.camel@lap75545.ornl.gov> <adafxxeu495.fsf@cisco.com>
	 <1199391187.7561.38.camel@lap75545.ornl.gov>
	 <1199391609.7561.46.camel@lap75545.ornl.gov>
	 <20080103181127.054dd917@cuia.boston.redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Oak RIdge National Laboratory
Date: Thu, 03 Jan 2008 18:18:34 -0500
Message-Id: <1199402314.6854.0.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-03 at 18:11 -0500, Rik van Riel wrote:
> On Thu, 03 Jan 2008 15:20:09 -0500
> David Dillow <dillowda@ornl.gov> wrote:
> 
> > diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> > index 950228f..6e7e3c8 100644
> > --- a/drivers/infiniband/ulp/srp/ib_srp.c
> > +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> > @@ -423,8 +423,8 @@ static void srp_remove_work(struct work_struct *work)
> >  	list_del(&target->list);
> >  	spin_unlock(&target->srp_host->target_lock);
> >  
> > -	srp_remove_host(target->scsi_host);
> >  	scsi_remove_host(target->scsi_host);
> > +	srp_remove_host(target->scsi_host);
> >  	ib_destroy_cm_id(target->cm_id);
> >  	srp_free_target_ib(target);
> >  	scsi_host_put(target->scsi_host);
> 
> These last two look suspicious.  Are you freeing target before
> freeing target->scsi_host or does the code simply not do what
> it looks like it's doing? :)
> 
> (no, I haven't looked at the IB code - I'm probably wrong)

srp_free_target_ib() just frees the buffers for the target, and
scsi_host_put() does the actual cleanup once the refcount drops to zero.

Dave
