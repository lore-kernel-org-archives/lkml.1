Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZKCWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZKCWCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZKCWCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:02:16 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:57913 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbZKCWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:02:13 -0500
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
Date: Tue, 3 Nov 2009 23:01:50 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <200911021832.59035.elendil@planet.nl> <20091102173837.GB22046@csn.ul.ie>
In-Reply-To: <20091102173837.GB22046@csn.ul.ie>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XhK8KFWl4pYC5hC"
Message-Id: <200911032301.59662.elendil@planet.nl>
X-OriginalArrivalTime: 03 Nov 2009 22:02:17.0077 (UTC) FILETIME=[4EA3FA50:01CA5CD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_XhK8KFWl4pYC5hC
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 02 November 2009, Mel Gorman wrote:
> On Mon, Nov 02, 2009 at 06:32:54PM +0100, Frans Pop wrote:
> > On Monday 02 November 2009, Mel Gorman wrote:
> > > vmscan: Help debug kswapd issues by counting number of rewakeups and
> > > premature sleeps
> > >
> > > There is a growing amount of anedotal evidence that high-order
> > > atomic allocation failures have been increasing since 2.6.31-rc1.
> > > The two strongest possibilities are a marked increase in the number
> > > of GFP_ATOMIC allocations and alterations in timing. Debugging
> > > printk patches have shown for example that kswapd is sleeping for
> > > shorter intervals and going to sleep when watermarks are still not
> > > being met.
> > >
> > > This patch adds two kswapd counters to help identify if timing is an
> > > issue. The first counter kswapd_highorder_rewakeup counts the number
> > > of times that kswapd stops reclaiming at one order and restarts at a
> > > higher order. The second counter kswapd_slept_prematurely counts the
> > > number of times kswapd went to sleep when the high watermark was not
> > > met.
> >
> > What testing would you like done with this patch?
>
> Same reproduction as before except post what the contents of
> /proc/vmstat were after the problem was triggered.

With a representative test I get 0 for kswapd_slept_prematurely.
Tested with .32-rc6 + patches 1-3 + this patch.


--Boundary-00=_XhK8KFWl4pYC5hC
Content-Type: text/plain;
  charset="iso-8859-15";
  name="vmstat"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="vmstat"

nr_free_pages 4841
nr_inactive_anon 103124
nr_active_anon 305446
nr_inactive_file 20214
nr_active_file 9217
nr_unevictable 400
nr_mlock 400
nr_anon_pages 364727
nr_mapped 2907
nr_file_pages 74823
nr_dirty 1
nr_writeback 0
nr_slab_reclaimable 2749
nr_slab_unreclaimable 4024
nr_page_table_pages 4286
nr_kernel_stack 177
nr_unstable 0
nr_bounce 0
nr_vmscan_write 226841
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 0
nr_shmem 18
pgpgin 651718
pgpgout 918016
pswpin 10144
pswpout 226833
pgalloc_dma 2193
pgalloc_dma32 1965234
pgalloc_normal 0
pgalloc_movable 0
pgfree 1972499
pgactivate 124982
pgdeactivate 387354
pgfault 2237876
pgmajfault 7305
pgrefill_dma 1538
pgrefill_dma32 388961
pgrefill_normal 0
pgrefill_movable 0
pgsteal_dma 67
pgsteal_dma32 305556
pgsteal_normal 0
pgsteal_movable 0
pgscan_kswapd_dma 192
pgscan_kswapd_dma32 419147
pgscan_kswapd_normal 0
pgscan_kswapd_movable 0
pgscan_direct_dma 576
pgscan_direct_dma32 299638
pgscan_direct_normal 0
pgscan_direct_movable 0
pginodesteal 2504
slabs_scanned 40960
kswapd_steal 250714
kswapd_inodesteal 6259
kswapd_highorder_rewakeup 22
kswapd_slept_prematurely 0
pageoutrun 3502
allocstall 975
pgrotated 226573
unevictable_pgs_culled 4251
unevictable_pgs_scanned 0
unevictable_pgs_rescued 33344
unevictable_pgs_mlocked 43192
unevictable_pgs_munlocked 42780
unevictable_pgs_cleared 2
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0

--Boundary-00=_XhK8KFWl4pYC5hC--
