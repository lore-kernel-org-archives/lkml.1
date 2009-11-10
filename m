Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZKJTuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZKJTuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbZKJTuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:50:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:59480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbZKJTuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:50:51 -0500
Message-ID: <4AF9C402.9040800@kernel.org>
Date: Wed, 11 Nov 2009 04:50:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org> <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu>
In-Reply-To: <20091110193705.GA9011@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> In this case, as the second function needs to release to free the old 
>> map, the extra unlock/lock pair is actually necessary.  Splitting into 
>> two functions is fine but I think it would be better to fix it first 
>> and then split them in following patches so that it can be bisected if 
>> I screw up while splitting, right?
> 
> i think Linus's point was that this hack was the last straw that broke 
> the camel's back, and that we are better off with a clean solution 
> straight away. If you send the clean approach i can help test it on a 
> good number of boxes.

If you're talking about the locking itself, there really is no clean
solution at this point.  Until vmalloc locking is updated, we'll have
to do locking impedance matching in percpu code.  I'm still not quite
sure whether we really need to update vmalloc code to be irqsafe.

If you're talking about the three way return value, which I do agree
to be quite ugly, I think it will be a lot safer to have three patches
- one to fix the deadlock, another to fix the return value and the
final one to de-uglify the function, especially as we're pretty late
in the release cycle.

Thanks.

-- 
tejun
