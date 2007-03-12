Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXCLWAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXCLWAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932713AbXCLWAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:00:54 -0400
Received: from ozlabs.org ([203.10.76.45]:35647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbXCLWAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:00:53 -0400
Date: Mon, 12 Mar 2007 17:00:42 -0500
From: Anton Blanchard <anton@samba.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rik van Riel <riel@redhat.com>, Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070312220042.GA807@kryten>
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E2E244.8040009@yahoo.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Nick,

> Anyway, I'll keep experimenting. If anyone from MySQL wants to help look
> at this, send me a mail (eg. especially with the sched_setscheduler issue,
> you might be able to do something better).

I took a look at this today and figured Id document it:

http://ozlabs.org/~anton/linux/sysbench/

Bottom line: it looks like issues in the glibc malloc library, replacing
it with the google malloc library fixes the negative scaling:

# apt-get install libgoogle-perftools0
# LD_PRELOAD=/usr/lib/libtcmalloc.so /usr/sbin/mysqld

Anton
