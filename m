Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZEHWW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZEHWW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZEHWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:22:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZEHWWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:22:50 -0400
Message-ID: <4A04B021.10004@redhat.com>
Date: Fri, 08 May 2009 18:20:17 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, hannes@cmpxchg.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
       linux-mm@kvack.org, elladan@eskimo.com, npiggin@suse.de,
       cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       minchan.kim@gmail.com
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class
 citizen
References: <20090430181340.6f07421d.akpm@linux-foundation.org>	<20090430215034.4748e615@riellaptop.surriel.com>	<20090430195439.e02edc26.akpm@linux-foundation.org>	<49FB01C1.6050204@redhat.com>	<20090501123541.7983a8ae.akpm@linux-foundation.org>	<20090503031539.GC5702@localhost>	<1241432635.7620.4732.camel@twins>	<20090507121101.GB20934@localhost>	<20090507151039.GA2413@cmpxchg.org>	<20090507134410.0618b308.akpm@linux-foundation.org>	<20090508081608.GA25117@localhost>	<20090508125859.210a2a25.akpm@linux-foundation.org> <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
In-Reply-To: <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The patch seems reasonable but the changelog and the (non-existent)
>> design documentation could do with a touch-up.
> 
> Is it right that I as a user can do things like mmap my database
> PROT_EXEC to get better database numbers by making other
> stuff swap first ?

Yes, but only if your SELinux policy allows you to
mmap something that's both executable and writable
at the same time.

> You seem to be giving everyone a "nice my process up" hack.

A user who wants to slow the system down has always
been able to do so.

I am not convinced that the potential disadvantages
of giving mapped referenced executable file pages an
extra round trip on the active file list outweighs
the advantages of doing so for normal workloads.

-- 
All rights reversed.
