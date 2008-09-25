Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYIYEGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYIYEGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYIYEFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:05:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:47094 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYIYEFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:05:51 -0400
Message-ID: <13c67e2c0809242105t77ca9a6k2faf1e85064967aa@mail.gmail.com>
Date: Wed, 24 Sep 2008 21:05:47 -0700
From: "Ani Sinha" <kernel@anirban.org>
To: linux-kernel@vger.kernel.org, kernel@anirban.org, mingo@elte.hu
Subject: wait_event_interruptible_timeout
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed an issue with wait_event_interruptible_timeout() API
which I will try to explain below:

wait_event_interruptible_timeout() is supposed to wait until one of
the following happens:

(a)    Timeout occurs (with no signals or the event of interest
happening), in which case it returns 0

(b)   The process receives a signal and wakes up prematurely (i.e.,
before its timeout expired or the event of interest occurred). In this
case, it returns –ERESTARTSYS. I will come back to this later.

(c)    Of course, the last obvious way to wake up is that the event of
interest occurs and it wakes up all (or one) process on the wait
queue. In that case, it returns the # of jiffies that is left before
the timeout would have occurred (unslept or balance jiffies).


What if I really wanted to sleep for timeout interval and no more?
That is to say, if I wake up on a signal and I wanted to know how many
jiffies I did used up while sleeping and how many I am left with (just
like poll or select does)? That way,  when I retry the API, I can tell
it to sleep only by the amount of my balance sleeping time.
Unfortunately, the interface looses this information since it
overrides the return value with ERESTARTSYS. I feel there is a need to
modify the code in order to correct this behavior. I am more than
willing to propose a patch but before I do so, I wanted to know what
the community thinks about it.

Thanks,

Ani

P.S: Please CC me separately as I am not on the mailing list.

====
Anirban Sinha
GNU/Kernel Developer
Zeugma Systems, Canada.
