Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbYHKE0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbYHKE0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 00:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYHKE0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 00:26:41 -0400
Received: from gw.goop.org ([64.81.55.164]:33597 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbYHKE0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 00:26:40 -0400
Message-ID: <489FBF6A.40402@goop.org>
Date: Sun, 10 Aug 2008 21:26:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       npiggin@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] stack and rcu interaction bug in smp_call_function_mask()
References: <20080808193753.GA21964@linux-os.sc.intel.com> <200808101624.15112.nickpiggin@yahoo.com.au>
In-Reply-To: <200808101624.15112.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Nice debugging work.
>
> I'd suggest something like the attached (untested) patch as the simple
> fix for now.
>
> I expect the benefits from the less synchronized, multiple-in-flight-data
> global queue will still outweigh the costs of dynamic allocations. But
> if worst comes to worst then we just go back to a globally synchronous
> one-at-a-time implementation, but that would be pretty sad!
>   

What if we went the other way and strictly used queue-per-cpu?  It means 
multicast would require multiple enqueueing operations, which is a bit 
heavy, but it does make dequeuing and lifetime management very simple...

    J
