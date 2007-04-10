Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbXDJD7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbXDJD7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXDJD67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:58:59 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:2397 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932969AbXDJD67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:58:59 -0400
Message-ID: <461B0B7F.1030802@rtr.ca>
Date: Mon, 09 Apr 2007 23:58:55 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Chris Snook <csnook@redhat.com>, Paa Paa <paapaa125@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl> <46128175.2090506@redhat.com> <4612852C.2030801@rtr.ca> <4612A854.1070702@cfl.rr.com> <4613C612.5040600@rtr.ca> <4615160A.4090506@cfl.rr.com> <46151FCD.6000700@rtr.ca> <461A51D0.3000708@cfl.rr.com>
In-Reply-To: <461A51D0.3000708@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Mark Lord wrote:
>> Phillip Susi wrote:
>>> Sounds like this is a serious bug in the WD firmware.
>>
>> For personal systems, yes.  For servers, probably not a bug.
>>
>> Disabling readahead means faster execution queued commands,
>> since it doesn't have to "linger" and do unwanted read-ahead.
>> So this bug is a "feature" for random access servers.
>> And a big nuisance for everything else.
> 
> I think you misunderstand the bug.  The bug is not that the drive 
> disables internal readahead; the bug is that host supplied readahead 
> requests work so horribly.  It is a good thing that the drive allows the 
> host to control the readahead, but something is wrong if the drive's 
> readahead is WAY better than any the host can perform.

Well, in this case, it has already been determined that switching
to a different Linux I/O scheduler gives back most of the performance.

But the drive can do readahead better than the OS:  With the OS,
everything is broken up into discrete requests, whereas with the 
drive firmware, it can continuously update it's readahead projections,
even in the midst of a command.  So it does have an advantage.

But again, only the WD Raptor seems to have serious problems here.
Other drives cope well with readahead + NCQ just fine.

Cheers
