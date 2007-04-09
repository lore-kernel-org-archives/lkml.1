Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXDICMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXDICMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 22:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXDICMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 22:12:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbXDICMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 22:12:33 -0400
Message-ID: <4619A101.5030600@redhat.com>
Date: Sun, 08 Apr 2007 22:12:17 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: root <swordfish@onetbd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Scheduler: Improving the scheduler performance.
References: <1175967725.5798.13.camel@localhost> <8762.1176044803@turing-police.cc.vt.edu>
In-Reply-To: <8762.1176044803@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Sat, 07 Apr 2007 23:42:20 +0600, root said:
> 
>> As we know that, linux scheduler use separate runqueue for every CPU of
>> a multiprocessor system, which having an active and an expired array.If
>> we use only one expired array, then the CPUs of a multiprocessor system
>> will be able to share their expired task via the accumulated expired
>> array,
> 
> I got this far, and the first thought that popped into my head was:
> 
> "Wow.  This might actually win on a UP or small MP (2-15 CPU).  But the
> lock contention on a big 512-CPU machoflops box is likely going to *suck*".
> 
> For that matter, my quick eyeballing of the code, although it doesn't *find*
> any race conditions, doesn't convince me there's any protection taken to make
> sure there aren't any.  Is there some subtle algorithmic trick I'm missing
> to ensure Nothing Bad Can Happen?

Lock contention is going to be the least of your worries.

Destroying CPU affinity is the big one I suspect.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
