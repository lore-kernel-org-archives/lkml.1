Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZBZNgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZBZNgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZBZNgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:36:36 -0500
Received: from www.tglx.de ([62.245.132.106]:55712 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZBZNgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:36:36 -0500
Message-Id: <20090226133339.875832967@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 26 Feb 2009 13:35:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_kill has a counterpart sys_tgkill which allows to send signals to
a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.

Aside of the asymetry it is a show stopper for migrating applications
from other unix-alike RTOSes.

The following patch series implements rt_tgsigqueueinfo and hooks it
up for x86.

Find below the raw documentation.

Thanks,

        tglx
----

NAME
       rt_tgsigqueueinfo - Send signal information to a signal to a thread

SYNOPSIS
       long sys_rt_tgsigqueueinfo (int tgid, int tid, int sig, siginfo_t *uinfo);

DESCRIPTION

       rt_tgsigqueueinfo sends signal sig information uinfo to the
       thread with the thread ID tid in the thread group tgid.  (By
       contrast, rt_sigqueueinfo(2) can only be used to send a signal
       info to a process (i.e., thread group) as a whole, and the
       signal will be delivered to an arbitrary thread within that
       process.)

RETURN VALUE

       rt_tgsigqueueinfo returns 0 on success; otherwise,
       rt_sigqueueinfo returns one of the errors listed in the
       "Errors" section.

ERRORS
       -EFAULT
              An invalid value for uinfo was specified.

       -EINVAL
              An invalid TID, TGID or signal was specified.

       -EPERM
              Permission denied.  For the required permissions,
              see rt_sigqueueinfo(2).

       -ESRCH
              No process with the specified thread ID and thread group
              ID exists. 

