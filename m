Return-Path: <linux-kernel-owner+w=401wt.eu-S1767052AbXDEPaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767052AbXDEPaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767060AbXDEPaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:30:14 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:37301 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767050AbXDEPaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:30:11 -0400
Message-ID: <4615160A.4090506@cfl.rr.com>
Date: Thu, 05 Apr 2007 11:30:18 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Chris Snook <csnook@redhat.com>, Paa Paa <paapaa125@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl> <46128175.2090506@redhat.com> <4612852C.2030801@rtr.ca> <4612A854.1070702@cfl.rr.com> <4613C612.5040600@rtr.ca>
In-Reply-To: <4613C612.5040600@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2007 15:30:20.0225 (UTC) FILETIME=[51F6E310:01C77797]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15098.000
X-TM-AS-Result: No--6.396900-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> The drive firmware readahead is inherently *way* more effective than
> other forms, and without it, sequential read performance really suffers.
> Regardless of how software tries to compensate.

Why?  As the platter spins under the head, the drive can either read or 
ignore the data.  As long as it keeps reading the track, it can't go any 
faster.  Whether in response to its own readahead or to the request 
queue from the host, either way it should read the data.  If its own 
readahead is faster, then either the host must not be properly 
performing readahead and keeping the drive request queue filled with 
sequential requests, or the drive firmware must be broken and decides to 
ignore the data as it passes under the head, and instead go back to pick 
it up on the next rotation.

> This is mostly a problem with the WD Raptor drive, and some other WD 
> drives.
> I have not yet encountered/noticed the problem with other brands.

Sounds like this is a serious bug in the WD firmware.


