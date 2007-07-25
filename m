Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbXGYP3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbXGYP3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbXGYP2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:28:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973AbXGYP2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:28:54 -0400
Message-ID: <46A76C09.6000602@redhat.com>
Date: Wed, 25 Jul 2007 11:28:09 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Eric St-Laurent <ericstl34@sympatico.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
References: <20070721210005.000228000@chello.nl>	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>	 <20070722081010.GA6317@mail.ustc.edu.cn>	 <1185093236.6344.87.camel@localhost.localdomain>	 <46A46E4B.7050007@yahoo.com.au> <1185338106.7105.44.camel@perkele> <46A6DD7F.1050505@yahoo.com.au>
In-Reply-To: <46A6DD7F.1050505@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> What *I* think is supposed to happen is that newly read in pages get
> put on the inactive list, and unless they get accessed againbefore
> being reclaimed, they are allowed to fall off the end of the list
> without disturbing active data too much.
> 
> I think there is a missing piece here, that we used to ease the reclaim
> pressure off the active list when the inactive list grows relatively
> much larger than it (which could indicate a lot of use-once pages in
> the system).
> 
> Andrew got rid of that logic for some reason which I don't know, but I
> can't see that use-once would be terribly effective today (so your
> results don't surprise me too much).

I suspect that reason is that use-once works great for
page cache pages, but anonymous pages share the same
LRUs and need a more balanced aging approach.

The result: an LRU list that works ok for both types
of pages most of the time, but falls over in some
workloads.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
