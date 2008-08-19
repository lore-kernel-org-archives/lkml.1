Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYHSJKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYHSJKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbYHSJKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:10:43 -0400
Received: from ixia01.ro.gtsce.net ([212.146.94.66]:29312 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751039AbYHSJKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:10:43 -0400
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] splice: add ->splice_read support for /dev/zero
Date: Tue, 19 Aug 2008 12:07:42 +0300
User-Agent: KMail/1.10.0 (Linux/2.6.26-1-686; KDE/4.1.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <1218074455-17901-1-git-send-email-opurdila@ixiacom.com> <20080818214318.7142ae3e.akpm@linux-foundation.org>
In-Reply-To: <20080818214318.7142ae3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191207.42550.opurdila@ixiacom.com>
X-OriginalArrivalTime: 19 Aug 2008 09:10:37.0381 (UTC) FILETIME=[71B34750:01C901DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 18 Aug 2008 21:43:18 -0700

> > Preallocating the zero page is simpler and faster with the relatively
> > small (?) drawback of using an extra page of memory.
>
> How much faster is it?  What workloads/benchmarks/etc?
>

I should have said "theoretically faster" :)

I did not perform any tests, but, did I assumed correctly that it is going to 
be faster preallocating it then allocating it in every splice call?

> > Maybe when CONFIG_EMBEDED is selected we can switch to dynamically
> > allocating the page?
>
> One more page won't kill us.  People might want one-page-per-node, too.
> But that all depends on what the benefits and applications of this are..

Its the reverse of splice for /dev/null. Sometimes you don't care of the data 
pushed through the socket (e.g. protocol payload in networking testing). 

BTW, the patch its buggy, I'll send a new version for linux-next if you decide 
its worth it.

Thanks,
tavi

