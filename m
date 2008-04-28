Return-Path: <linux-kernel-owner+w=401wt.eu-S935766AbYD1QAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935766AbYD1QAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934142AbYD1QAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:00:46 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:36630 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136AbYD1QAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=etBxdGeFMvkj1wx9dPJjoA8rx+pQ77JlJ6p70163gEErZFqlrCTL1Q+/1JUdN4+E5NtJ86SN6z8pIIDZgE2mJJzWgP76cTY5p6BRkXeoCS4iPrj2gyUA65zZ4SfvRKJGVDzJjxUsAmHij4Voa+uEEhc+dgvcoluYZm6gUJywR1o=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][-mm] [2/2] Simple stats for memory resource controller
Date: Mon, 28 Apr 2008 21:30:29 +0530
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, menage@google.com,
       balbir@in.ibm.com, dhaval@linux.vnet.ibm.com
References: <200804052340.02386.balajirrao@gmail.com> <48036CB4.5050700@linux.vnet.ibm.com>
In-Reply-To: <48036CB4.5050700@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804282130.30188.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 08:09:48 pm Balbir Singh wrote:
> Balaji Rao wrote:
> > This patch implements trivial statistics for the memory resource controller.
> > 
> > Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> > CC: Balbir Singh <balbir@linux.vnet.ibm.com>
> > CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a860765..ca98b21 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -47,6 +47,8 @@ enum mem_cgroup_stat_index {
> >  	 */
> >  	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
> >  	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
> > +	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
> > +	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
> > 
> >  	MEM_CGROUP_STAT_NSTATS,
> >  };
> > @@ -198,6 +200,13 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem, int flags,
> >  		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
> >  	else
> >  		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
> > +
> > +	if (charge)
> > +		__mem_cgroup_stat_add_safe(stat,
> > +				MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
> > +	else
> > +		__mem_cgroup_stat_add_safe(stat,
> > +				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
> >  }
> > 
> >  static struct mem_cgroup_per_zone *
> > @@ -897,6 +906,8 @@ static const struct mem_cgroup_stat_desc {
> >  } mem_cgroup_stat_desc[] = {
> >  	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
> >  	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
> > +	[MEM_CGROUP_STAT_PGPGIN_COUNT] = {"pgpgin", 1, },
> > +	[MEM_CGROUP_STAT_PGPGOUT_COUNT] = {"pgpgout", 1, },
> >  };
> > 
> >  static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
> > 
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Hi, Andrew,
> 
> Could you please include these statistics in -mm.
> 
> Balbir
> 
> 
Hi Andrew,

Now that Balbir Singh has ACKed it, could you please include it in -mm ?

-- 
Warm Regards,

Balaji Rao
Dept. of Mechanical Engineering
NITK
