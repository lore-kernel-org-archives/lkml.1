Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZCMD6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZCMD6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZCMD6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:58:40 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:43070 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZCMD6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:58:39 -0400
Message-ID: <49B9D9E3.5080108@davidnewall.com>
Date: Fri, 13 Mar 2009 14:28:27 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] (latest tip) make dequeue_task less confusing
References: <49B8CE2B.8070402@davidnewall.com> <20090312095518.GB16721@elte.hu> <1236864997.6075.22.camel@marge.simson.net> <49B94E43.6000405@davidnewall.com> <20090313004558.GD19544@elte.hu>
In-Reply-To: <20090313004558.GD19544@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Newall <davidn@davidnewall.com> wrote:
>   
>> No.  On further consideration, I don't like my patch.
>>     
>
> With the __dequeue_task()+inline suggestion i made i think it 
> would be a micro-optimization and would not break symmetry in a 
> significant way.

What I realised, upon closer examination, is that enqueue_task has the
same issue (with wakeup); and that the one places where sleep and wakeup
are set are in a single call for each, to (de|en)activate_task. If it
made sense to do what I suggested, then it should be done all the way,
that is, move the sleep and wakeup code to those two places, and
replicate the (admittedly smaller) *queue_task and *activate_task at
those points. This smacks of premature optimisation.
