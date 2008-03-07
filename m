Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbYCGLtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbYCGLtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757986AbYCGLsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:48:55 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34464 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbYCGLsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:48:54 -0500
Date: Fri, 7 Mar 2008 11:48:49 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Adam Litke <agl@us.ibm.com>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [BUG] 2.6.25-rc4 hang/softlockups after freeing hugepages
Message-ID: <20080307114849.GC26229@csn.ul.ie>
References: <1204824183.5294.62.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1204824183.5294.62.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/03/08 12:23), Lee Schermerhorn didst pronounce:
> Test platform:  HP Proliant DL585 server - 4 socket, dual core AMD with
> 32GB memory.
> 
> I first saw this on 25-rc2-mm1 with Mel's zonelist patches, while
> investigating the interaction of hugepages and cpusets.  Thinking that
> it might be caused by the zonelist patches, I went back to 25-rc2-mm1
> w/o the patches and saw the same thing.  It sometimes takes a while for
> the softlockups to start appearing, and I wanted to find a fairly
> minimal duplicator.  Meanwhile 25-rc3 and rc4 have come out, so I tried
> the latest upstream kernel and see the same thing.
> 
> To duplicate the problem, I need only:
> 
> + log into the platform as root in one window and:
> 
> 	echo N >/proc/sys/vm/nr_hugepages
> 	echo 0 >proc/sys/vm/nr_hugepages
> 

Uncool, I am going to try and find a machine to reproduce this one but
in case I have no luck, can you try setting the following in your
.config which may rattle out something please?

CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_VM=y

and as you have DEBUG_INFO, can you say what line is ffffffff8027b693 ?

> In my case, N=64.  If I look, before echoing 0, I see 16 hugepages
> allocated on each of the 4 nodes, as expected.
> 
> + then in another window, log in again.  
> 
> Sometimes it will hang during the 2nd login and I'll never see a shell
> prompt. 

My initial guess was that is is something to do with page_table_lock but as
you didn't get to fault in huge pages, it doesn't make much sense.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
