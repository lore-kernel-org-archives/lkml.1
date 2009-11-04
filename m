Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZKDCDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZKDCDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZKDCDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:03:03 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37004 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZKDCDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:03:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DLVGk9V8v3WZaIuXHLTP22RWqb1bgZpxcTiwbMKDmxLgWMHOLqURUOTsKGFEuXzZyw
         eiAKih812pvf/aEQe4ng55ekmCNsRmxcB7IvCuSeCCKZAWYIP6diP9fzlD7fjxmr8rhi
         2zCAsvKi88MC2WYNNa34XcqwGJ5ajFBFM7Bo0=
Date: Wed, 4 Nov 2009 03:03:01 +0100
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
	failures V2
Message-ID: <20091104020301.GA7037@bizet.domek.prywatny>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <20091023165810.GA4588@bizet.domek.prywatny> <20091023211239.GA6185@bizet.domek.prywatny> <9ec2d7290910240646p75b93c68v6ea1648d628a9660@mail.gmail.com> <20091028114208.GA14476@bizet.domek.prywatny> <20091028115926.GW8900@csn.ul.ie> <20091030142350.GA9343@bizet.domek.prywatny> <20091102203034.GC22046@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102203034.GC22046@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 08:30:34PM +0000, Mel Gorman wrote:
> Does applying the following on top make any difference?
> 
> ==== CUT HERE ====
> PM: Shrink memory before suspend

No, this patch didn't change anything either.

IIRC I get failures while free(1) shows as much as 20MB free RAM
(ie. without buffers/caches).  Additionaly nr_free_pages (from
/proc/vmstat) stays at about 800-1000 under heavy memory pressure
(gitk on full linux repository).


--- babbling follows ---

Hmm, I wonder if it's really timing issue then wouldn't be the case
that lowering swappiness sysctl would make problem more visible?
I've vm.swappiness=15, would testing with higher value make any sense?

Thanks.
