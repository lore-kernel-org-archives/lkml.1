Return-Path: <linux-kernel-owner+w=401wt.eu-S1161071AbXAZQ65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbXAZQ65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161066AbXAZQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:58:56 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:27669 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161071AbXAZQ6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:58:51 -0500
Message-ID: <45BA3343.8070703@cfl.rr.com>
Date: Fri, 26 Jan 2007 11:58:43 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Denis Vlasenko <vda.linux@googlemail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@vger.kernel.org
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <45B90D19.60106@cfl.rr.com> <45B916F2.4070906@tls.msk.ru> <200701252211.39017.vda.linux@googlemail.com> <45BA2628.4030502@rtr.ca>
In-Reply-To: <45BA2628.4030502@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 16:59:00.0391 (UTC) FILETIME=[46870B70:01C7416B]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14958.003
X-TM-AS-Result: No--4.771400-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> You guys need to backup in this thread.
> 
> Every example of O_DIRECT here could be replaced with
> calls to mmap(), msync(), and madvise() (or posix_fadvise).
> 
> In addition to being at least as fast as O_DIRECT,
> these have the added benefit of using the page cache (avoiding reads for 
> data already present, handling multiple
> users of the same data, etc..).

Please actually _read_ the thread.  In every one of my posts I have 
shown why this is not the case.

To briefly rehash the core of the argument, there is no way to 
asynchronously manage IO with mmap, msync, madvise -- instead you take 
page faults or otherwise block, thus stalling the pipeline.

