Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZKFJvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZKFJvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 04:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbZKFJvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 04:51:37 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:59182 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363AbZKFJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:51:36 -0500
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Fri, 6 Nov 2009 10:51:37 +0100
User-Agent: KMail/1.9.9
Cc: Chris Mason <chris.mason@oracle.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910262206.13146.elendil@planet.nl> <200911052114.36718.elendil@planet.nl>
In-Reply-To: <200911052114.36718.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911061051.40443.elendil@planet.nl>
X-OriginalArrivalTime: 06 Nov 2009 09:51:40.0994 (UTC) FILETIME=[BD89CA20:01CA5EC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 November 2009, Frans Pop wrote:
> On Monday 26 October 2009, Frans Pop wrote:
> > On Tuesday 20 October 2009, Mel Gorman wrote:
> > > I've attached a patch below that should allow us to cheat. When it's
> > > applied, it outputs who called congestion_wait(), how long the
> > > timeout was and how long it waited for. By comparing before and
> > > after sleep times, we should be able to see which of the callers has
> > > significantly changed and if it's something easily addressable.
> >
> > The results from this look fairly interesting (although I may be a bad
> > judge as I don't really know what I'm looking at ;-).
> >
> > I've tested with two kernels:
> > 1) 2.6.31.1: 1 test run
> > 2) 2.6.31.1 + congestion_wait() reverts: 2 test runs
>
> I've taken another look at the data from this debug patch, resulting in
> these graphs: http://people.debian.org/~fjp/tmp/kernel/congestion.pdf
>
> I think the graph may show the reason for the congestion_wait()
> regression. Horizontal axis shows time, vertical axis shows number of
> logged congestion_wait calls per type.

I'm sorry. My initial version had a skewed time axis (showed occurrences 
instead of actual time). I've now uploaded a corrected version:
http://people.debian.org/~fjp/tmp/kernel/congestion.pdf

I've also uploaded a second version that shows cumulative delay per type, 
which probably gives a better insight:
http://people.debian.org/~fjp/tmp/kernel/congestion2.pdf

For both the top chart is without the revert, the bottom one after the 
revert.
