Return-Path: <linux-kernel-owner+w=401wt.eu-S1762599AbXEKJJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762599AbXEKJJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759120AbXEKJI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:08:29 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:47235 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662AbXEKJI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:08:27 -0400
Date: Fri, 11 May 2007 10:08:24 +0100
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2, mode:0x84020
Message-ID: <20070511090823.GA29273@skynet.ie>
References: <Pine.LNX.4.64.0705101447120.12874@schroedinger.engr.sgi.com> <20070510220657.GA14694@skynet.ie> <Pine.LNX.4.64.0705101510500.13404@schroedinger.engr.sgi.com> <20070510221607.GA15084@skynet.ie> <Pine.LNX.4.64.0705101522250.13504@schroedinger.engr.sgi.com> <20070510224441.GA15332@skynet.ie> <Pine.LNX.4.64.0705101547020.14064@schroedinger.engr.sgi.com> <20070510230044.GB15332@skynet.ie> <Pine.LNX.4.64.0705101601220.14471@schroedinger.engr.sgi.com> <1178863002.24635.4.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1178863002.24635.4.camel@rousalka.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/05/07 07:56), Nicolas Mailhot didst pronounce:
> Le jeudi 10 mai 2007 à 16:01 -0700, Christoph Lameter a écrit :
> > On Fri, 11 May 2007, Mel Gorman wrote:
> > 
> > > Nicholas, could you backout the patch
> > > dont-group-high-order-atomic-allocations.patch and test again please?
> > > The following patch has the same effect. Thanks
> > 
> > Great! Thanks.
> 
> The proposed patch did not apply
> 
> + cd /builddir/build/BUILD
> + rm -rf linux-2.6.21
> + /usr/bin/bzip2 -dc /builddir/build/SOURCES/linux-2.6.21.tar.bz2
> + tar -xf -
> + STATUS=0
> + '[' 0 -ne 0 ']'
> + cd linux-2.6.21
> ++ /usr/bin/id -u
> + '[' 499 = 0 ']'
> ++ /usr/bin/id -u
> + '[' 499 = 0 ']'
> + /bin/chmod -Rf a+rX,u+w,g-w,o-w .
> + echo 'Patch #2 (2.6.21-mm2.bz2):'
> Patch #2 (2.6.21-mm2.bz2):
> + /usr/bin/bzip2 -d
> + patch -p1 -s
> + STATUS=0
> + '[' 0 -ne 0 ']'
> + echo 'Patch #3 (md-improve-partition-detection-in-md-array.patch):'
> Patch #3 (md-improve-partition-detection-in-md-array.patch):
> + patch -p1 -R -s
> + echo 'Patch #4 (bug-8464.patch):'
> Patch #4 (bug-8464.patch):
> + patch -p1 -s
> 1 out of 1 hunk FAILED -- saving rejects to file
> include/linux/pageblock-flags.h
> .rej
> 6 out of 6 hunks FAILED -- saving rejects to file mm/page_alloc.c.rej
> 
> Backing out dont-group-high-order-atomic-allocations.patch worked and

Odd, because they should have been the same thing. As long as it
worked..

> seems to have cured the system so far (need to charge it a bit longer to
> be sure)
> 

The longer it runs the better, particularly under load and after
updatedb has run. Thanks a lot for testing

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
