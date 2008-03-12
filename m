Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYCLCeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYCLCeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYCLCeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:34:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46305 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYCLCeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:34:10 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5249"; a="1050721"
Message-ID: <47D7411E.1000009@qualcomm.com>
Date: Tue, 11 Mar 2008 19:34:06 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com> <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
In-Reply-To: <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Menage wrote:
> On Tue, Mar 11, 2008 at 6:23 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>>  The thing is though that the very next thing we do there is run early
>>  userspace. Which begs the question, shouldn't we just do it from early
>>  user-space then ?
> 
> Seems simplest to me. We have an early boot script that creates a
> "system" cpuset and moves all tasks into it. It seems to work fine for
> us.

Suppose we were to do it from kernel. What's the right way to create a cgroup
without mounting a cgroupfs ?
I just want to play with it. There are a couple of advantages that I see for
doing it from kernel. We can move 'kthreadd' and idle threads into the 'boot'
cgroup early on and therefor later on won't even have to iterate through the
tasks and stuff. Whereas user-space has to iterate through tasks and be smart
about threads that are pinned and stuff. Not a big deal but if kernel code is
simple enough maybe it makes sense.

So, any pointers. How do I do create_cgroup() without fs mounted ?

Max
