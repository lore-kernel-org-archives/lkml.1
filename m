Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZEUW5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZEUW5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZEUW5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:57:13 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:38415 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZEUW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:57:12 -0400
Message-ID: <4A15DC45.5020509@nortel.com>
Date: Thu, 21 May 2009 16:57:09 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Jean-Paul Calderone <exarkun@twistedmatrix.com>
Subject: Re: Allow signaling a process by all its thread ids?
References: <1242944179.10298.11.camel@odie.local>
In-Reply-To: <1242944179.10298.11.camel@odie.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 May 2009 22:57:11.0033 (UTC) FILETIME=[796B4690:01C9DA67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Holm Thøgersen wrote:
> There is a bug report at https://bugs.launchpad.net/bugs/341239 where
> the question is asked. Should it be possible to signal a process with
> kill(2) by passing any of the thread ids belong to the process as
> argument to kill?

Based on POSIX, from the perspective of the kernel I think that a tid
that is not a tgid should result in ESRCH for the kill() syscall.

Such a tid would however be valid for the tgkill or tkill syscalls.

Makes sense to me.  I suspect such a change would break a lot of
not-strictly-compliant programs though.

In the meantime, the pid file scenario could be modified to store both
the tid and pid (using userspace terminology now) and use the tgkill()
syscall.  It should be noted that tgkill() is linux-specific.

Chris
