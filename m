Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZK3RBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZK3RBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZK3RBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:01:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZK3RBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:01:03 -0500
Message-ID: <4B13FA4E.1070901@zytor.com>
Date: Mon, 30 Nov 2009 09:01:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: using kernel headers in libc headers
References: <a36005b50911300837s6fe4da73s973ccbe7401b9989@mail.gmail.com>
In-Reply-To: <a36005b50911300837s6fe4da73s973ccbe7401b9989@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 08:37 AM, Ulrich Drepper wrote:
> 
> It's likely in everybody's interest to get the kernel headers used.
> But for this mode #ifdefs are needed.  I'm willing to do the work.
> Easy enough to do when I'm going through the headers one-by-one to
> enable them in glibc.  But I don't want to start this work unless it's
> going to be accepted.  The symbols would be something like
> 
>   __USE_MISC
> 
> or
> 
>   __USE_GNU
> 
> These are not macros which the user must define.  The user sets macros
> like _GNU_SOURCE etc which then set all the appropriate __USE_* macros
> (see "info libc 'Feature Test Macros'" on machines with glibc
> installed).  These names are somewhat glibc-specific but other libcs
> can (or already have) adapt them.
> 
> So, what do you say?

Speaking for myself, I think #ifdefs utterly suck for this purpose.
First of all, because they tie back a glibc internal (the naming of
feature test macros) with the kernel headers.  Second of all, because it
really makes it much harder to get things right.  Third, because it
conflicts with the usage model in the kernel itself in a way that is
likely to cause breakage.

A better way is to factor out subsets; if <linux/sched.h> has too many
things, we can break out the POSIX parts into <linux/sched_posix.h> or
(certainly better if we have more than one of these)
<linux/sched/posix.h> which can also be included by <linux/sched.h>.

glibc can then choose to include or not include <linux/sched/posix.h>
depending on its configuration.  The configuration macros remain a glibc
internal detail.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

