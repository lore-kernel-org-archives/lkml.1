Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbXJLG3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbXJLG3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXJLG3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:29:30 -0400
Received: from [212.12.190.216] ([212.12.190.216]:33352 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760050AbXJLG33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:29:29 -0400
From: Al Boldi <a1426z@gawab.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Reserve N process to root
Date: Fri, 12 Oct 2007 09:29:10 +0300
User-Agent: KMail/1.5
Cc: LKML Kernel <linux-kernel@vger.kernel.org>, g@0xff.cl,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
References: <200710120002.37341.a1426z@gawab.com> <200710120837.23586.a1426z@gawab.com> <4768FB5E-33D1-45B9-AA71-1D979F56B1B1@mac.com>
In-Reply-To: <4768FB5E-33D1-45B9-AA71-1D979F56B1B1@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120929.10770.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Oct 12, 2007, at 01:37:23, Al Boldi wrote:
> > You have a point, and resource-controllers can probably control DoS
> > a lot better, but the they also incur more overhead.  Think of this
> > "lockout prevention" patch as a near zero overhead safety valve.
>
> But why do you need to add "lockout prevention" if it already
> exists?

I said this before, but I'll say it again: it's about overhead!

> With CFS' extremely efficient per-user-scheduling (hopefully
> soon to be the default) there are only two forms of lockout by non-
> root processes:  (1) Running out of PIDs in the box's PID-space
> (think tens or hundreds of thousands of processes), or (2) Swap-
> storming the box to death.  To put it bluntly trying to reserve free
> PID slots is attacking the wrong end of the problem and your so
> called "lockout prevention" could very easily ensure that 10 PIDs are
> available even if the user has swapstormed the box with the PIDs he
> does have.

I think you are reading this wrong.  It's not about reserving PIDs, it's 
about exceeding the max-threads limit.  This limit is global and affects 
every user including root, which is good, as this allows the sysadmin to 
fence the system into a controllable state.  So once the system reaches the 
fence, sysadmin-intervention allows root to exceed the fence.

Again, this is much nicer with real resource-controllers, but again it's also 
more overhead.


Thanks!

--
Al

