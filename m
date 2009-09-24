Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbZIXVvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbZIXVvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZIXVvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:51:12 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:47166 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZIXVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:51:11 -0400
Message-ID: <4ABBE9B7.1050505@gmail.com>
Date: Thu, 24 Sep 2009 23:50:47 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: Dont use openat()
References: <4ABB6EB7.7000002@gmail.com> <20090924131250.GA15132@elte.hu> <4ABB767D.6080004@gmail.com> <4ABBDF77.3090106@redhat.com>
In-Reply-To: <4ABBDF77.3090106@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 24 Sep 2009 23:50:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Dumazet wrote:
>>> We can certainly remove that reliance - wanna send a patch for it?
> 
> Come on, the silliness has to stop.  The kernel must be recent and to
> use it adequately the C library also must be recent.  And "recent" is
> not even correct anymore: the functions are available for more then two
> years.  Removing the use of the modern interfaces makes everything
> slower and might even re-introduce race conditions my patch fixed.
> 

First time I ear that C library *must* be recent. This was never
mentionned in Documentation/Changes, "Minimal Requirements"

"perf list" can be 100x slower, and even racy, I dont mind. At all.

$ time perf list >/dev/null 2>/dev/null

real    0m0.001s
user    0m0.000s
sys     0m0.001s

With openat(), I cannot use "perf" on machines I can only change kernel,
since changing glibc is too risky for legacy apps. I could use static and
private glibc, but last time I tried this I lost few hours and failed.

If modern interfaces means : "Upgrade glibc or die, silly you..."
I prefer to be silly, and keep increasing linux usability, even
if I dont have the chance to have a modern lab with up2date distros.

BTW, oprofile compiles perfectly on RHEL4 and 'old' glibc.

Thanks
