Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZKMJE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZKMJE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZKMJEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:04:23 -0500
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:56560 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820AbZKMJEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:04:21 -0500
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/5] Reduce GFP_ATOMIC allocation failures, candidate fix V3
Date: Fri, 13 Nov 2009 10:04:21 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1258054235-3208-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911131004.25293.elendil@planet.nl>
X-OriginalArrivalTime: 13 Nov 2009 09:04:25.0673 (UTC) FILETIME=[4C726390:01CA6440]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 November 2009, Mel Gorman wrote:
> Changelog since V2
>   o Dropped the kswapd-quickly-notice-high-order patch. In more detailed
>     testing, it made latencies even worse as kswapd slept more on
>     high-order congestion causing order-0 direct reclaims.
>   o Added changes to how congestion_wait() works
>   o Added a number of new patches altering the behaviour of reclaim

I have tested this series on top of .32-rc7. First impression is that it 
does seem to improve my test case, but does not yet completely solve it.

My last gitk instance now loads more smoothly for most of the time it takes 
to complete, but I still see a choke point where things freeze for a while 
and where I get SKB allocation errors from my wireless.
However, that choke point does seem to happen later and to be shorter than 
without the patches.

I'll try to do additional tests (with .31). If you'd like me to run this 
set with your instrumentation patch for congestion_wait, then please let 
me know.

Chris Mason's analysis regarding dm-crypt workqueues in reply to your other 
mail looks very interesting.

Cheers,
FJP
