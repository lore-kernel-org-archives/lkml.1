Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZGXNNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZGXNNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZGXNNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:13:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:38561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZGXNNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:13:16 -0400
Subject: Re: report a bug about sched_rt
From: Peter Zijlstra <peterz@infradead.org>
To: sen wang <wangsen.linux@gmail.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Jul 2009 15:14:50 +0200
Message-Id: <1248441290.6987.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't top post -- again!

On Fri, 2009-07-24 at 21:04 +0800, sen wang wrote:
> Linux is used in many fieldes. SCHED_OTHER tasks is important to
> embedded system.

Irrelevant.

> if there is a running state task（a realtime task）, how can we
> shcedule the idle task up?

Because it ran out of bandwidth.

> It is ridiculous！
> 
> since the throttle has a bug, why not fix it?

It doesn't have a bug, therefore I won't fix it.

The throttle limits the RT tasks to a bandwidth w of u/p.
Since real-time scheduling is about determinism a maximum bandwidth
larger than the minimum bandwidth specified by w is useless since it
cannot be relied upon.

Therefore we don't run RT tasks beyond their bandwidth limit.

Go read up on scheduling theory.

Now you might want a bandwidth of 100% for your RT application (not
something I can recommend for the overall health of your machine) in
which case you're free to change this setting:

  echo -1 > /proc/sys/kernel/sched_rt_runtime_us

Should do that for you. Also read:

  Documentation/scheduler/sched-rt-group.txt


