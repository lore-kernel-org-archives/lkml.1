Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbYKLGl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbYKLGl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYKLGlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:41:47 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:51438 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYKLGlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:41:47 -0500
Message-ID: <491A7AAB.2070103@colorfullife.com>
Date: Wed, 12 Nov 2008 07:41:47 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: cboulte@gmail.com, Nadia.Derbey@bull.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SYSVIPC - Fix the ipc structures initialization
References: <20081028145952.620752409@bull.net> <20081028150041.857635775@bull.net> <4f3ee3290810290211y75a2d0eaoe666496e25496260@mail.gmail.com> <20081111141603.f0e7fa8d.akpm@linux-foundation.org>
In-Reply-To: <20081111141603.f0e7fa8d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> I don't understand what's going on... I hope I'm not the only one who
>> still get it because I doubt about this bug.
>>     
One thing is odd:
The test app uses fork(), two processes.
One process constantly does
    msgctl(0, IPC_STAT, &buf);

The other process creates a new msg queue, then it destroys it.
But: The probablity that the new queue has the msqid is 0 is tiny 
[impossible?].
That means the idr_find() call should [must?] fail.
But then the spin_lock() should never be executed. Why do you get an 
oops in that call?

Do you still use the test app that is on bugzilla?

>>     
>
> Time is starting to press on this one.  Is there something which we can
> revert which would fix this bug?
>
> Thanks.
>   

