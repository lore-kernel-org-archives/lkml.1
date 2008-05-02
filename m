Return-Path: <linux-kernel-owner+w=401wt.eu-S935181AbYEBNLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935181AbYEBNLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbYEBNLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:11:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759837AbYEBNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:10:58 -0400
Date: Fri, 2 May 2008 06:10:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phil Oester <kernel@linuxace.com>
Cc: Ryan Roth <ryanroth@sbcglobal.net>, Ryan.Roth@CH2M.com,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults
 onMacBookStarting With 2.6.24.5 Kernel
Message-Id: <20080502061018.5557d067.akpm@linux-foundation.org>
In-Reply-To: <20080502121945.GA18667@linuxace.com>
References: <20080501130444.cc5c63e8.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>
	<20080501133003.be723364.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>
	<481A5276.4040607@sbcglobal.net>
	<20080501170239.9b740877.akpm@linux-foundation.org>
	<481A5A94.2080400@sbcglobal.net>
	<20080501173408.384b4fc3.akpm@linux-foundation.org>
	<20080502020815.GA5155@linuxace.com>
	<20080501192838.8ecb81c2.akpm@linux-foundation.org>
	<20080502121945.GA18667@linuxace.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 05:19:45 -0700 Phil Oester <kernel@linuxace.com> wrote:

> On Thu, May 01, 2008 at 07:28:38PM -0700, Andrew Morton wrote:
> > On Thu, 1 May 2008 19:08:15 -0700 Phil Oester <kernel@linuxace.com> wrote:
> > 
> > > FWIW, I recently upgraded some boxes to 2.6.24.x, and started seeing tons of
> > > qmail segfaults, which look remarkably similar to the above problem.  2.6.21
> > > did not exhibit this issue.
> > > 
> > > May  1 22:06:03 mail80 kernel: qmail-smtpd[5319]: segfault at 0 ip 4884b473 sp fffeec1c error 4 in libc-2.6.so[487dd000+14e000]
> > > May  1 22:06:03 mail80 kernel: qmail-smtpd[5491]: segfault at 0 ip 4884b473 sp ffb7179c error 4 in libc-2.6.so[487dd000+14e000]
> > > May  1 22:06:03 mail80 kernel: qmail-smtpd[4669]: segfault at 0 ip 4884b473 sp fff3135c error 4 in libc-2.6.so[487dd000+14e000]
> > > May  1 22:06:05 mail80 kernel: qmail-smtpd[5906]: segfault at 0 ip 4884b473 sp ffe1b24c error 4 in libc-2.6.so[487dd000+14e000]
> > > May  1 22:06:07 mail80 kernel: qmail-smtpd[5898]: segfault at 0 ip 4884b473 sp ffe4e27c error 4 in libc-2.6.so[487dd000+14e000]
> > > May  1 22:06:11 mail80 kernel: qmail-smtpd[5840]: segfault at 0 ip 4884b473 sp ffe04a2c error 4 in libc-2.6.so[487dd000+14e000]
> > > 
> > 
> > Can you try fiddling with the norandmaps boot option and
> > /proc/sys/kernel/randomize_va_space?
> 
> echo 0 > /proc/sys/kernel/randomize_va_space does not make any difference (and
> is equivalent to norandmaps boot option according to docs).
> 
> Unless you have other ideas, I can try to bisect this later today.

No, I can't suggest anything else to try, sorry.

Traditionally i386 never printed that message (in fact neither architecture
should - it allows poeple to spam the logs, but it is at least
ratelimited).

In 2.6.23, i386 _does_ generate that message, in arch/i386/mm/fault.c

In 2.6.24 the i386 and x86_64 fault handlers were renamed to
arch/x86/mm/fault_[32|64].c and both versions generated the message.

In 2.6.25 they were unified into a single arch/x86/mm/fault.c, and both
architectures print the message.

So afacit 2.6.23 _should_ be printing the message if qmail is indeed
generating a segfault.  But there's always the possibility that the
message-printing code was simply broken in 2.6.23, and that your qmail has
always been generating segfaults.

Are any other problems observeable?  Does qmail continue to operate
normally in 2.6.24?

