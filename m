Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYLPSf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYLPSf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYLPSfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:35:14 -0500
Received: from smtp-out.google.com ([216.239.45.13]:9325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYLPSfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:35:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=mgiWjhvPF+sMoYUWuHM5Spqql7g8g3ATX9gMgNGRiUm+2bqSNJVXw1B+YDGkudrSn
	gjZweQ04DB4um5W0bTl0Q==
MIME-Version: 1.0
In-Reply-To: <4947A53B.9050600@cn.fujitsu.com>
References: <494234B0.5@cn.fujitsu.com> <4944754F.8050503@cn.fujitsu.com>
	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	 <4945B200.7020207@cn.fujitsu.com> <1229328783.14605.11.camel@twins>
	 <49462890.1040002@cn.fujitsu.com> <1229337829.14605.41.camel@twins>
	 <6599ad830812160141v5ed5d453h36f825b069554e57@mail.gmail.com>
	 <6599ad830812160442p349fac09u9627ac2b81f76905@mail.gmail.com>
	 <4947A53B.9050600@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 10:35:09 -0800
Message-ID: <6599ad830812161035q7becedf1u3d90f4064f9b0964@mail.gmail.com>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 4:55 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> This avoids accessing a destroyed cgroup, but still race with cgroup_create.
> You sugguested call cgroup_create_dir() before calling subsystems' create()
> method.
>

I think that if we need a fix for 2.6.28 I'll just make cgroup_path()
check for a NULL dentry in the passed cgroup, rather than shuffling
any code around. That combined with a simple RCU free in
cgroup_diput() should do the trick - I think I'll leave the existing
synchronize_rcu() at the beginning of cgroup_diput() in case we need
it for more reasons than I originally mentioned in the comment there.

Paul
