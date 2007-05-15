Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbXEOA5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbXEOA5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbXEOA5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:57:49 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:47643 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbXEOA5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:57:49 -0400
Message-ID: <46490573.7030101@cs.umass.edu>
Date: Mon, 14 May 2007 20:57:23 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: tingy@cs.umass.edu
CC: Ingo Molnar <mingo@elte.hu>, William Lee Irwin III <wli@holomorphy.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com> <20070514115049.GA28721@elte.hu> <4648D381.6040808@cs.umass.edu>
In-Reply-To: <4648D381.6040808@cs.umass.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>
>
> It is possible to do something like this in check_preemption ?
>
>       delta = curr->fair_key - first->fair_key;
>
>       if (delta > ??? [scale it as you wish] ||
>            (curr->key > first->key) && (curr->wait_runtime > ??? 
> [simple funtion of curr->weight]) )
>              preempt
Forgive me, there is typo in the above check. It should be "less than" 
since we are controlling negative lags.

           (curr->key > first->key) && (curr->wait_runtime < ??? [simple 
funtion of curr->weight]) )

>
> A limit control on wait_runtime may prevent a high weight task from 
> running for too long, so that others get executed a little earlier. 
> Just a thought :-)
>
>
Ting
