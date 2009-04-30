Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbZD3Nfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbZD3Nfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762893AbZD3Nf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:35:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48829 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbZD3Nf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:35:27 -0400
Date: Thu, 30 Apr 2009 14:35:24 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Replace the watermark-related union in struct zone with
	a watermark[] array
Message-ID: <20090430133524.GC21997@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-19-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.0904221251350.14558@chino.kir.corp.google.com> <20090427170054.GE912@csn.ul.ie> <alpine.DEB.2.00.0904271340320.11972@chino.kir.corp.google.com> <20090427205400.GA23510@csn.ul.ie> <alpine.DEB.2.00.0904271400450.11972@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904271400450.11972@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:04:03PM -0700, David Rientjes wrote:
> On Mon, 27 Apr 2009, Mel Gorman wrote:
> 
> > > I thought the suggestion was for something like
> > > 
> > > 	#define zone_wmark_min(z)	(z->pages_mark[WMARK_MIN])
> > > 	...
> > 
> > Was it the only suggestion? I thought just replacing the union with an
> > array would be an option as well.
> > 
> > The #define approach also requires setter versions like
> > 
> > static inline set_zone_wmark_min(struct zone *z, unsigned long val)
> > {
> > 	z->pages_mark[WMARK_MIN] = val;
> > }
> > 
> > and you need one of those for each watermark if you are to avoid weirdness like
> > 
> > zone_wmark_min(z) = val;
> > 
> > which looks all wrong.
> 
> Agreed, but we only set watermarks in a couple of different locations and 
> they really have no reason to change otherwise, so I don't think it's 
> necessary to care too much about how the setter looks.
> 
> Adding individual get/set functions for each watermark seems like 
> overkill.
> 

I think what you're saying that you'd be ok with

zone_wmark_min(z)
zone_wmark_low(z)
zone_wmark_high(z)

and z->pages_mark[WMARK_MIN] =
and z->pages_mark[WMARK_LOW] =
and z->pages_mark[WMARK_HIGH] =

?

Is that a significant improvement over what the patch currently does? To
me, it seems more verbose.

> I personally had no problem with the union struct aliasing the array, I 
> think ->pages_min, ->pages_low, etc. are already very familiar.
> 

Can the people who do have a problem with the union make some sort of
comment on how they think it should look?

Obviously, I'm pro-the-current-patch :/

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
