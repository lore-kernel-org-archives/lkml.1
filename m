Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZJ0XeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZJ0XeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 19:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbZJ0XeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 19:34:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:8424 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbZJ0XeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 19:34:01 -0400
X-ExtLoop1: 1
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
 failures V2
From: reinette chatre <reinette.chatre@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>, Kalle Valo <kalle.valo@iki.fi>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20091027104017.GC8900@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
	 <1256226219.21134.1493.camel@rc-desk>  <20091027104017.GC8900@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 16:34:05 -0700
Message-Id: <1256686445.21134.10091.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 03:40 -0700, Mel Gorman wrote:
> On Thu, Oct 22, 2009 at 08:43:38AM -0700, reinette chatre wrote:
> > On Thu, 2009-10-22 at 07:22 -0700, Mel Gorman wrote:
> > > [Bug #14141] order 2 page allocation failures in iwlagn
> > > 	Commit 4752c93c30441f98f7ed723001b1a5e3e5619829 introduced GFP_ATOMIC
> > > 	allocations within the wireless driver. This has caused large numbers
> > > 	of failure reports to occur as reported by Frans Pop. Fixing this
> > > 	requires changes to the driver if it wants to use GFP_ATOMIC which
> > > 	is in the hands of Mohamed Abbas and Reinette Chatre. However,
> > > 	it is very likely that it has being compounded by core mm changes
> > > 	that this series is aimed at.
> > 
> > Driver has been changed to allocate paged skb for its receive buffers.
> > This reduces amount of memory needed from order-2 to order-1. This work
> > is significant and will thus be in 2.6.33. 
> > 
> 
> What do you want to do for -stable in 2.6.31?
> 

I have just posted two patches to stable. The first is to address a bug
in which buffer loss occurs when there is an allocation failure and the
second is what Frans has been testing that reduces the noise when these
allocations fail. They are:

  iwlwifi: fix potential rx buffer loss­­­­­­­
de0bd50845eb5935ce3d503c5d2f565d6cb9ece1 in linux-2.6
  iwlwifi: reduce noise when skb allocation fails
­­­­­­­f82a924cc88a5541df1d4b9d38a0968cd077a051 in linux-2.6

Reinette


