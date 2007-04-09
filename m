Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXDIOps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXDIOps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbXDIOps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:45:48 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:48248 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933265AbXDIOpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:45:47 -0400
Message-ID: <461A51D0.3000708@cfl.rr.com>
Date: Mon, 09 Apr 2007 10:46:40 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Chris Snook <csnook@redhat.com>, Paa Paa <paapaa125@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl> <46128175.2090506@redhat.com> <4612852C.2030801@rtr.ca> <4612A854.1070702@cfl.rr.com> <4613C612.5040600@rtr.ca> <4615160A.4090506@cfl.rr.com> <46151FCD.6000700@rtr.ca>
In-Reply-To: <46151FCD.6000700@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2007 14:46:41.0030 (UTC) FILETIME=[E2747260:01C77AB5]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15106.000
X-TM-AS-Result: No--5.142600-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Phillip Susi wrote:
>> Sounds like this is a serious bug in the WD firmware.
> 
> For personal systems, yes.  For servers, probably not a bug.
> 
> Disabling readahead means faster execution queued commands,
> since it doesn't have to "linger" and do unwanted read-ahead.
> So this bug is a "feature" for random access servers.
> And a big nuisance for everything else.

I think you misunderstand the bug.  The bug is not that the drive 
disables internal readahead; the bug is that host supplied readahead 
requests work so horribly.  It is a good thing that the drive allows the 
host to control the readahead, but something is wrong if the drive's 
readahead is WAY better than any the host can perform.


In other words, if the host is sending down multiple sequential reads 
such that the queue always has a request for the next sector, the drive 
should be hitting its maximum physical transfer rate.  If it doesn't, 
then something is very broken with its firmware.

It is still possible though, that the kernel is simply not issuing its 
own readahead effectively so the queue ends up empty at times and the 
disk goes idle.  This would be worth investigating before letting WD 
know they have a serious firmware problem.
