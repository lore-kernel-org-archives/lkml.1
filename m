Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZGQWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZGQWMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbZGQWMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:12:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60088 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZGQWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:12:54 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Duplicate vsyscall/vdso gettimeofday implementations on x86_64
From: Andi Kleen <andi@firstfloor.org>
References: <1247868130.8334.40.camel@localhost.localdomain>
Date: Sat, 18 Jul 2009 00:12:52 +0200
In-Reply-To: <1247868130.8334.40.camel@localhost.localdomain> (john stultz's message of "Fri, 17 Jul 2009 15:02:10 -0700")
Message-ID: <87eisfvtzv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> writes:

> I think the implementation in vclock_gettime.c is nice, as it mostly
> reuses the clock_gettime() code, but I don't think it actually gets
> called.

It depends on what glibc uses.

> Andi: You wrote the vclock_gettime.c, do you have any pointers about
> where you were going with this? Is there a reason you didn't clean it up
> when you implemented it originally?

The old style vsyscall cannot call the vDSO because it doesn't know
where it is mapped. And the new style vDSO cannot necessarily
call the old one vsyscall because there were plans 
to removing the old style vsyscall for some new programs to avoid
the last non randomized mapping (but that never got implemented). 

That is why there are two different ways to do this.

Neither can also call into the kernel of course.

In the current setup you could call into the static vsyscall, 
but that might need to be revised later.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
