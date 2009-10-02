Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZJBJcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZJBJcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbZJBJcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:32:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33332 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398AbZJBJcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:32:19 -0400
Date: Fri, 2 Oct 2009 10:32:26 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091002093226.GJ21906@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.k2B.ZNTxKB@chimera> <200910021111.55749.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200910021111.55749.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 11:11:52AM +0200, Frans Pop wrote:
> On Thursday 01 October 2009, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
> > Subject	: order 2 page allocation failures in iwlagn
> > Submitter	: Frans Pop <elendil@planet.nl>
> > Date		: 2009-09-06 7:40 (26 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
> > Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> I'm not sure about this.
> 
> The error messages from failed allocations should now be a lot less as a 
> result of this commit:
> commit f82a924cc88a5541df1d4b9d38a0968cd077a051
> Author: Reinette Chatre <reinette.chatre@intel.com>
> Date:   Thu Sep 17 10:43:56 2009 -0700
>     iwlwifi: reduce noise when skb allocation fails
> 
> That commit is in mainline, and I'm not sure if it is important enough for 
> a stable update (AFAICT it's not listed for 2.6.31.2).
> 
> That commit is mostly cosmetic, but possibly the real regression is not in 
> iwlagn but in the way memory is freed/defragmented. That aspect was also 
> reported by Bartlomiej (#14016) and was extensively discussed (without a 
> clear conclusion) here: http://lkml.org/lkml/2009/8/26/140.
> 
> My own feeling is that Bartlomiej is correct and that something has changed 
> since .29 and that on average we do have less higher order areas available 
> after the system has been in use for some time, but I can't substantiate 
> that. I do know that before .30 I had never seen the SKB allocation 
> errors.
> 
> Main problem is that it's hard to deliberately and reproducibly get the 
> system in a state where the errors occur.
> 

Apparently, Karol Lewandowski (cc added) has a reliable
reproduction case for when the firmware loading problem occurs
(http://lkml.org/lkml/2009/9/30/242). While it's not the same problem exactly,
it's probable they're related. I'm hoping the problem commit can be identified
by his bisection whenever he gets around to it.

> I certainly do feel that the kernel should try to make sure higher order 
> allocations remain possible during system use. They are not only needed 
> shortly after boot: drivers can be loaded/unloaded at any time. OTOH Mel 
> probably does have a point that really high order GFP_ATOMIC allocations 
> by drivers make no sense [1].
> 

While they don't make sense, I accept that the problem is apparently
occuring more now than it did so something has changed that is not
obvious to normal testing. Hopefully Karol will be able to help us out.

> Anyway, I have no problems with this BR being closed.
> 
> Cheers,
> FJP
> 
> [1] <20090921133704.GO12726@csn.ul.ie>
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
