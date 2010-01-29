Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179Ab0A2N4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0A2N4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 08:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493Ab0A2N4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 08:56:24 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:17158 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753636Ab0A2N4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 08:56:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwAAEd3YktLd/sX/2dsb2JhbAAIgyvHNo9/gSuCPlkE
X-IronPort-AV: E=Sophos;i="4.49,368,1262581200"; 
   d="scan'208";a="54813426"
Message-ID: <4B62E904.9020401@teksavvy.com>
Date: Fri, 29 Jan 2010 08:56:20 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
References: <4B5FA147.5040802@teksavvy.com> <4B610FDA.50104@teksavvy.com> <4B6113C7.201@teksavvy.com> <201001281152.20352.rjw@sisk.pl> <4B61964F.6060307@teksavvy.com> <4B619C6D.9030205@teksavvy.com> <20100128142437.GA7139@csn.ul.ie>
In-Reply-To: <20100128142437.GA7139@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Thu, Jan 28, 2010 at 09:17:17AM -0500, Mark Lord wrote:
..
>> Rather than wasting time trying to bisect a full major kernel revision,
>> I think instead I'll just focus on mm/page_alloc.c.
..
> Well, it might not eve be necessary. In the patch I sent you, it pointed
> the finger at commit 5f8dcc21211a3d4e3a7a5ca366b469fb88117f61 being the
> problem in that case. I believe your problem is a variation of the
> slowdown-in-swapping problem except in your case it manifests as
> GFP_ATOMIC allocations failing.
> 
> If the fix does not help you, then I'll take a fresh look at the other
> commits with your particular problem in mind.
..

Last night, I installed 2.6.32.7, plus the patch you sent.
So far, no allocation faults.

I'll leave it running for another day or so, and then perhaps revert
the one patch to see which of the two things (new kernel, or patch)
is responsible for the difference.

The changelog for 2.6.32.7 included something to fix default rsize/wsize
values on NFS.  Dunno if this might have had an effect or not,
but when it was failing.. NFS (order 1) was the most frequent case.

-ml
