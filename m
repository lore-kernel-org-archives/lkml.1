Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZGQWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZGQWCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbZGQWCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:02:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60682 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903AbZGQWCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:02:54 -0400
Subject: Duplicate vsyscall/vdso gettimeofday implementations on x86_64
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@tglx.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 15:02:10 -0700
Message-Id: <1247868130.8334.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andi, Ingo, Thomas,
	I ran across an oddity recently in the x86_64 vsyscall code.
Specifically I was looking at the vsyscall clock_gettime()
implementation in arch/x86/vdso/vclock_gettime.c, and noticed there is a
vsyscall gettimeofday implementation there too! This seems to duplicate
the do_vgettimeofday implementation in arch/x86/kernel/vsyscall_64.c

I think the implementation in vclock_gettime.c is nice, as it mostly
reuses the clock_gettime() code, but I don't think it actually gets
called.

I'm a little worried about just switching it out, and cleaning it up, as
I don't know enough yet about how the vgettimeofday is called from glibc
(I thought it was a static "jump to this page and run" mapping).

Andi: You wrote the vclock_gettime.c, do you have any pointers about
where you were going with this? Is there a reason you didn't clean it up
when you implemented it originally?

thanks
-john


