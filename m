Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbZKZNI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbZKZNI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760461AbZKZNI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:08:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:49709 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754235AbZKZNI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:08:56 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192IYodcDx2WW8UPcLXfieFKw24kN70uVsHvc/3TI
	Qa62OxXaRDT+iO
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20091126121945.GB13095@csn.ul.ie>
References: <20091126121945.GB13095@csn.ul.ie>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 14:08:57 +0100
Message-Id: <1259240937.7371.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 12:19 +0000, Mel Gorman wrote:
> (cc'ing the people from the page allocator failure thread as this might be
> relevant to some of their problems)
> 
> I know this is very last minute but I believe we should consider disabling
> the "low_latency" tunable for block devices by default for 2.6.32.  There was
> evidence that low_latency was a problem last week for page allocation failure
> reports but the reproduction-case was unusual and involved high-order atomic
> allocations in low-memory conditions. It took another few days to accurately
> show the problem for more normal workloads and it's a bit more wide-spread
> than just allocation failures.
> 
> Basically, low_latency looks great as long as you have plenty of memory
> but in low memory situations, it appears to cause problems that manifest
> as reduced performance, desktop stalls and in some cases, page allocation
> failures. I think most kernel developers are not seeing the problem as they
> tend to test on beefier machines and without hitting swap or low-memory
> situations for the most part. When they are hitting low-memory situations,
> it tends to be for stress tests where stalls and low performance are expected.

Ouch.  It was bad desktop stalls under heavy write that kicked the whole
thing off.

	-Mike

