Return-Path: <linux-kernel-owner+w=401wt.eu-S1751640AbZIYRIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbZIYRIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZIYRI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:08:29 -0400
Received: from ms01.sssup.it ([193.205.80.99]:55999 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751072AbZIYRI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:08:29 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2009 13:08:28 EDT
Message-ID: <4ABCEABC.4050200@gandalf.sssup.it>
Date: Fri, 25 Sep 2009 18:07:24 +0200
From: Michael Trimarchi <trimarchi@gandalf.sssup.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: sat <takeuchi_satoru@jp.fujitsu.com>
CC: lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Raistlin <raistlin@linux.it>
Subject: Re: massive_intr on CFS, BFS, and EDF
References: <4ABC068A.6070704@jp.fujitsu.com>
In-Reply-To: <4ABC068A.6070704@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
sat wrote:
> Hi,
>
> I tried massive_intr, a process scheduler's fairness and throughtput testing
> program for massive interactive processes, on vanilla 2.6.31, 2.6.31-bfs211
> (with BFS) and 2.6.31-edf(latest linus tree + EDF patch).
>
> CFS and BFS look good. CFS has better fairness, and BFS has better throughput.
> EDF looks unfair and is unstable. I tested 3 times and the tendency was the
> same.
Thank you for your testing, the instability problems you hit are due to
some bugs in our implementation, we'll try to reproduce and fix them.
Your test shows that we have some problems with how we handle fork();
the code attempts at distributing the bandwidth between the parent and
the child, and the fact that the children hang means that there is
something wrong in how we handle recharges. It is important to note that
the expected behavior of an edf scheduler is *not* a fair one. It has to
do its best to guarantee the deadlines of the admitted tasks.

Regards Michael
