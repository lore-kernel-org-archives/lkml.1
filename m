Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505Ab0ATAYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0ATAYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122Ab0ATAYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:24:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55829 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0ATAYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:24:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Cc: kosaki.motohiro@jp.fujitsu.com, Gleb Natapov <gleb@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       minchan.kim@gmail.com
In-Reply-To: <84144f021001190044s397c6665qb00af48235d2d818@mail.gmail.com>
References: <20100119082638.GK14345@redhat.com> <84144f021001190044s397c6665qb00af48235d2d818@mail.gmail.com>
Message-Id: <20100120091051.405D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Jan 2010 09:24:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Gleb,
> 
> On Tue, Jan 19, 2010 at 10:26 AM, Gleb Natapov <gleb@redhat.com> wrote:
> >> design would still be broken, no? Did you try using (or extending)
> >> posix_madvise(MADV_DONTNEED) for the guest address space? It seems to
> > After mlockall() I can't even allocate guest address space. Or do you mean
> > instead of mlockall()? Then how MADV_DONTNEED will help? It just drops
> > page table for the address range (which is not what I need) and does not
> > have any long time effect.
> 
> Oh right, MADV_DONTNEED is no good.

Off topic:

posix_madvise(MADV_DONTNEED) is nop. glibc's posix_madvise(MADV_DONTNEED)
don't call linux's madvise(MADV_DONTNEED).
It's because madvise(MADV_DONTNEED) is not POSIX compliant. 

The behavior of linux madvise(MADV_DONTNEED) is similar to Solaris (or *BSD) 
madvise(MADV_FREE).




