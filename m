Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZBCTDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZBCTDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBCTDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:03:10 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52719 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZBCTDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:03:09 -0500
Message-ID: <498893EE.9060107@cs.helsinki.fi>
Date: Tue, 03 Feb 2009 20:58:54 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator (try 2)
References: <20090123154653.GA14517@wotan.suse.de> <1232959706.21504.7.camel@penberg-laptop> <20090203101205.GF9840@csn.ul.ie>
In-Reply-To: <20090203101205.GF9840@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Mel Gorman wrote:
> The OLTP workload results could indicate a downside with using sysbench
> although it could also be hardware. The reports from the Intel guys have been
> pretty clear-cut that SLUB is a loser but sysbench-postgres on these test
> machines at least do not agree. Of course their results are perfectly valid
> but the discrepency needs to be explained or there will be a disconnect
> between developers and the performance people.  Something important is
> missing that means sysbench-postgres *may* not be a reliable indicator of
> TPC-C performance.  It could easily be down to the hardware as their tests
> are on a mega-large machine with oodles of disks and probably NUMA where
> the test machine used for this is a lot less respectable.

Yup. That's more or less what I've been saying for a long time now. The 
OLTP regression is not all obvious and while there has been plenty of 
talk about it (cache line ping-pong due to lack of queues, high order 
pages), I've yet to see a detailed analysis on it.

It would be interesting to know what drivers the Intel setup uses. One 
thing I speculated with Christoph at OLS is that the regression could be 
due to bad interaction with the SCSI subsystem, for example. That would 
explain why the regression doesn't show up in typical setups which have ATA.

Anyway, even if we did end up going forward with SLQB, it would sure as 
hell be less painful if we understood the reasons behind it.

			Pekka
