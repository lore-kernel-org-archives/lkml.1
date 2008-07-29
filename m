Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYG2Xo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYG2Xo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYG2XoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:44:06 -0400
Received: from gw.goop.org ([64.81.55.164]:42619 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYG2XoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:44:05 -0400
Message-ID: <488FAB3F.6050003@goop.org>
Date: Tue, 29 Jul 2008 16:43:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function call
 IPIs
References: <488FA8A9.6000005@goop.org>
In-Reply-To: <488FA8A9.6000005@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> This adds 8 queues for smp_call_function(), in order to avoid a
> bottleneck on a single global lock and list for function calls.  When
> initiating a function call, the sender chooses a queue based on its
> own processor id (if there are more than 8 processors, they hash down
> to 8 queues).  It then sends an IPI to the corresponding vector for
> that queue to each target CPU.  The target CPUs use the vector number
> to determine which queue they should scan for work.

I should point out that this patch depends on the earlier tlb.c 
unification patch, since it recycles the IPI vectors that series freed up.

    J
