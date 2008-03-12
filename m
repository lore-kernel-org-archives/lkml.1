Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYCLCxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYCLCxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYCLCxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:53:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18847 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYCLCxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:53:12 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5249"; a="1050907"
Message-ID: <47D74595.4080100@qualcomm.com>
Date: Tue, 11 Mar 2008 19:53:09 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	 <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	 <47D7411E.1000009@qualcomm.com> <6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
In-Reply-To: <6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Menage wrote:
> On Tue, Mar 11, 2008 at 7:34 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>>  Suppose we were to do it from kernel. What's the right way to create a cgroup
>>  without mounting a cgroupfs ?
> 
> There isn't really a way, but you could always kern_mount() a
> filesystem inside the kernel.
Aha, that's what I was missing. kern_mount(). Cool :).

>>  I just want to play with it. There are a couple of advantages that I see for
>>  doing it from kernel. We can move 'kthreadd' and idle threads into the 'boot'
>>  cgroup early on and therefor later on won't even have to iterate through the
>>  tasks and stuff.
> 
> Would this be done based on some boot commandline option? I don't
> think you'd want to do it unconditionally.
Hmm, I believe the original discussion was about doing it unconditionally.
Why not I guess ? It probably won't even affect your existing scripts since
they will be able to move tasks into another set just like they do now. The
only thing I can think of is that if your scripts use sched_load_balance then
they will now have to unset it in the 'boot' set as well. Otherwise since the
'boot' set will be non-exclusive (cpus and mems) it should not really affect
anything.
So what's your concern with unconditional 'boot' cgroup/cpuset ?

Max
