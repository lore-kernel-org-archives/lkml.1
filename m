Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYGVOyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYGVOyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYGVOy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:54:28 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:50778 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751753AbYGVOy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:54:27 -0400
Message-ID: <4885F496.3010305@davidnewall.com>
Date: Wed, 23 Jul 2008 00:24:14 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [TCP bug] stuck distcc connections in latest -git
References: <20080720.104411.81744468.davem@davemloft.net> <20080721133059.GA30637@elte.hu> <20080721134506.GA27598@elte.hu> <20080721182318.GA20940@elte.hu> <alpine.LFD.1.10.0807211131390.31863@woody.linux-foundation.org> <20080721184616.GA8442@elte.hu> <20080722112133.GA6575@elte.hu> <4885E482.5020502@davidnewall.com> <20080722135723.GA23077@elte.hu>
In-Reply-To: <20080722135723.GA23077@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Newall <davidn@davidnewall.com> wrote:
>   
>> You really should start that capture, and on both client and server. 
>> You don't need to dump everything, only traffic to or from 
>> server:distcc.
>>     
>
> It's not feasible. That box did in excess of 200 GB of network traffic 
> in the past 7 hours alone.

You only need distcc traffic, and perhaps only after it's hung.  With
250k outstanding per socket, are you certain that no traffic was sent? 
Is it certain that one packet wasn't being sent each three minutes?  I
suppose you're right and the stack really is stuck, but this is such an
easy thing to check and eliminate that you should do so.  I suppose,
too, that you should trace the server-side processes and confirm that
they are waiting for socket input.  You should dump tcp (for the distcc
port) next time the problem recurs and also check that the server
processes are waiting for socket input.
