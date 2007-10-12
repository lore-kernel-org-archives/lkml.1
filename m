Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbXJLFhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbXJLFhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXJLFh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:37:28 -0400
Received: from [212.12.190.28] ([212.12.190.28]:41614 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932380AbXJLFh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:37:27 -0400
From: Al Boldi <a1426z@gawab.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Reserve N process to root
Date: Fri, 12 Oct 2007 08:37:23 +0300
User-Agent: KMail/1.5
Cc: LKML Kernel <linux-kernel@vger.kernel.org>, g@0xff.cl,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
References: <200710120002.37341.a1426z@gawab.com> <46B8DC5E-CD66-40B3-BF82-05259F9D7288@mac.com>
In-Reply-To: <46B8DC5E-CD66-40B3-BF82-05259F9D7288@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120837.23586.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> Please don't trim CC lists
>
> On Oct 11, 2007, at 17:02:37, Al Boldi wrote:
> > David Newall wrote:
> >> Valdis.Kletnieks@vt.edu wrote:
> >>> What David meant was that "root will always have a slot" doesn't
> >>> *actually* help unless you *also* have a way to actually *spawn*
> >>> such a process.  In order to do the ps, kill, and so on that you
> >>> need to recover, you need to already have either a root shell
> >>> available, or a way to *get* a root shell that doesn't rely on a
> >>> non-root process (so /bin/su doesn't help here).
> >>
> >> That's right, although it's worse than that.  You need to have a
> >> process with CAP_SYS_ADMIN.  If root processes normally have that
> >> capability then the reserved slots may well disappear before you
> >> notice a problem.  If root processes normally don't have it, then
> >> you need to guarantee that one is already running.
> >
> > I once posted a patch to handle this DoS, but, as usual, it wasn't
> > accepted.  Go figure...
>
> This isn't really necessary any more with the new CFS scheduler.  If
> you want to prevent excess memory usage then you limit memory usage,
> not process count, so just set the system max process count to
> something absurdly high and leave the user counts down at the maximum
> a user might run.  Then as long as the sum of the user processes is
> less than the max number of processes (which you just set absurdly
> high or unlimited), you may still log in.  With the per-user
> scheduling enabled CFS allows you to run an optimistically-real-time
> game as one user and several thousand busy-loops as another user and
> get almost picture perfect 50% CPU distribution between the users.
> To me that seems a much better DoS-prevention system than limits
> which don't scale based on how many people are requesting resources.

You have a point, and resource-controllers can probably control DoS a lot 
better, but the they also incur more overhead.  Think of this "lockout 
prevention" patch as a near zero overhead safety valve.


Thanks!

--
Al

