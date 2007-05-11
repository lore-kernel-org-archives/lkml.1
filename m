Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbXEKOxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbXEKOxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbXEKOxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:53:25 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:29846 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXEKOxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:53:24 -0400
Subject: Re: [patch 1/6] Guest page hinting: core + volatile page cache.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Valdis.Kletnieks@vt.edu
Cc: virtualization@lists.osdl.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hubertus Franke <frankeh@watson.ibm.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <5056.1178894723@turing-police.cc.vt.edu>
References: <20070511135827.393181482@de.ibm.com>
	 <20070511135925.513572897@de.ibm.com>
	 <5056.1178894723@turing-police.cc.vt.edu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 11 May 2007 16:53:49 +0200
Message-Id: <1178895229.7695.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 10:45 -0400, Valdis.Kletnieks@vt.edu wrote:
> > The guest page hinting patchset introduces code that passes guest
> > page usage information to the host system that virtualizes the
> > memory of its guests. There are three different page states:
> 
> Possibly hiding in the patchset someplace where I don't see it, but IBM's
> VM hypervisor supported reflecting page faults back to a multitasking guest,
> giving a signal that the guest supervisor could use.  The guest would then
> look up which process owned that virtual page, and could elect to flag that
> process as in page-wait and schedule another process to run while the hypervisor
> was doing the I/O to bring the page in.  The guest would then get another
> interrupt when the page became available, which it could use to flag the
> suspended process as eligible for scheduling again.

That features is called pfault and is hidden in arch/s390/mm/fault.c.
Guest page hinting is different. The idea is that the guest (linux)
allows the host (z/VM) to remove the page from memory without writing it
to a paging device. With pfault z/VM has to write the page but tells its
guest that is has to retrieve the page before the current context can
continue if the guest accesses the page. So with pfault the host gets
the page back, with guest page hinting the guest does it.

> Not sure how that would fit into all this though - it looks like the
> "discard fault" does something similar, but only for pages marked volatile.
> Would it be useful/helpful to also deliver a similar signal for stable pages?

Pfault delivers a signal for stable pages, yes.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


