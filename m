Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbXIVS6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbXIVS6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 14:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbXIVS6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 14:58:36 -0400
Received: from sccrmhc12.comcast.net ([63.240.77.82]:55818 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXIVS6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 14:58:35 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Sep 2007 14:58:35 EDT
Subject: Re: Should parent's WIFSIGNALED(siginfo->si_status) be true EVEN
	IF the SIGNAL was caught by the child?
From: Nicholas Miell <nmiell@comcast.net>
To: "John Z. Bohach" <jzb2@aexorsyst.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200709221122.09523.jzb2@aexorsyst.com>
References: <200709221122.09523.jzb2@aexorsyst.com>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 11:52:14 -0700
Message-Id: <1190487134.2712.2.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 11:22 -0700, John Z. Bohach wrote:
> Hello,
> 
> It is unclear from the various documentions in the kernel and glibc what 
> the proper behaviour should be for the case when a child process 
> catches a SIGNAL (say for instance, SIGTERM), and then calls exit() 
> from within its caught SIGNAL handler.
> 
> Since the exit() will cause a SIGCHLD to the parent, and the parent 
> (let's say) has a SIGCHLD sigaction (SA_SIGINFO sa_flags set), should 
> the parent's WIFSIGNALED(siginfo->si_status) be true?
> 
> To recap, the WIFSIGNALED section of the waitpid() manpage says:
> 
> WIFSIGNALED(status)
>     returns true if the child process was terminated by a signal.
> 
> So the dilemna:  the child caught the signal, so it wasn't terminated by 
> a signal, but rather its signal handler (let's say) called exit.

POSIX says

WIFSIGNALED(stat_val)
        Evaluates to a non-zero value if status was returned for a child
        process that terminated due to the receipt of a signal that was
        not caught (see <signal.h>).
        
So there's no dilemma at all and Linux is non-conformant.
 
-- 
Nicholas Miell <nmiell@comcast.net>

