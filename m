Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbXFCVTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbXFCVTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXFCVTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:19:37 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:57078 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXFCVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:19:36 -0400
Message-ID: <46633047.1020707@cosmosbay.com>
Date: Sun, 03 Jun 2007 23:19:03 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
In-Reply-To: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 03 Jun 2007 23:19:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> Core code for the unsequential fdmap implementation. Random allocation,
> exact allocation, de-allocation and lookup are all O(1) operations.
> The only operation that is O(N) is the strict from-N-up kind of allocation,
> but that only used by F_DUPFD and it's definitely not frequently used
> (and current code is O(N) too).
> Like the "struct fdtable", the unsequential fdmap is RCU friendly too.
> 
> 
> 

Could you please provide a diffstat ?

Me think : "Huge patch, and icache pressure for what exact gain ?"

File descriptor allocation is dust compared to socket setup costs and network 
stuf. (Not speaking of close() wich is O(1) obviously)

If we want a different file descriptor allocation, why should we use a 
parallel structure, and adding one level of complexity ?

Instead of finding the first zero bit in a bitmap, we could just use a cyclic 
allocation, ie finding a zero bit from a 'last' position. Keeping fd_count 
would help not atempting a findzerobit in the case all bits are known to be set.


