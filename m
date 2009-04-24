Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbZDXOZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbZDXOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbZDXOZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:25:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38265 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbZDXOZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:25:10 -0400
Subject: Re: [PATCH 02/22] Do not sanity check order in the fast path
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090424092151.GA14283@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-3-git-send-email-mel@csn.ul.ie>
	 <1240416791.10627.78.camel@nimitz> <20090422171151.GF15367@csn.ul.ie>
	 <1240421415.10627.93.camel@nimitz> <20090423001311.GA26643@csn.ul.ie>
	 <1240450447.10627.119.camel@nimitz> <1240514784.10627.171.camel@nimitz>
	 <1240515930.10627.175.camel@nimitz>  <20090424092151.GA14283@csn.ul.ie>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 07:25:00 -0700
Message-Id: <1240583100.29485.5.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 10:21 +0100, Mel Gorman wrote:
> > dave@kernel:~/work/mhp-build$ ../linux-2.6.git/scripts/bloat-o-meter
> > i386-numaq-sparse.{1,2}/vmlinux 
> > add/remove: 0/0 grow/shrink: 9/16 up/down: 81/-99 (-18)
> > function                                     old     new   delta
> > st_int_ioctl                                2600    2624     +24
> > tcp_sendmsg                                 2153    2169     +16
> > diskstats_show                               739     753     +14
> > iov_shorten                                   49      58      +9
> > unmap_vmas                                  1653    1661      +8
> > sg_build_indirect                            449     455      +6
> > ahc_linux_biosparam                          251     253      +2
> > nlmclnt_call                                 557     558      +1
> > do_mount                                    1533    1534      +1
> 
> It doesn't make sense at all that text increased in size. Did you make clean
> between each .config change and patch application? Are you using distcc
> or anything else that might cause confusion? I found I had to eliminate
> distscc and clean after each patch application because sometimes
> net/ipv4/udp.c would sometimes generate different assembly when
> accessing struct zone. Not really sure what was going on there.

There's a ccache in there but no distcc.

I'll redo with clean builds.

-- Dave

