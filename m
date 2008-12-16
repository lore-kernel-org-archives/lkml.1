Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYLPJYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYLPJYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYLPJXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:23:53 -0500
Received: from smtp-out.google.com ([216.239.45.13]:32113 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYLPJXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:23:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=f5Xb6TUUmaTb7/MU9gRmDvKuvvRABDL2LA2H7vUyV4j88T2p6AxrAfug3EhFmjFQY
	Hu687DdCINGXGHXdkwYJA==
MIME-Version: 1.0
In-Reply-To: <20081215105053.89263708.kamezawa.hiroyu@jp.fujitsu.com>
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>
	 <4944754F.8050503@cn.fujitsu.com>
	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	 <6599ad830812141347k5d7e7e08vfc17855ea0ac981c@mail.gmail.com>
	 <4945B546.5040301@cn.fujitsu.com>
	 <20081215105053.89263708.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 16 Dec 2008 01:23:47 -0800
Message-ID: <6599ad830812160123x4a088632re220d081788b7187@mail.gmail.com>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 5:50 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> at creation:
>  - cpu_cgroup_populate() should record "tg" that "this cgroup has valid dentry"
> at deletion

Wouldn't moving the call to cgroup_create_dir() to before doing
subsystem initialization fix this problem more straightforwardly? Then
by the time the cpu subsytem create() callback is called, dentry will
already be valid.

Paul
