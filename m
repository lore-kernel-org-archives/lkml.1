Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZEUXLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZEUXLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZEUXLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:11:35 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:52210 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbZEUXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:11:35 -0400
Message-ID: <4A15DFA3.70802@nortel.com>
Date: Thu, 21 May 2009 17:11:31 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Jean-Paul Calderone <exarkun@twistedmatrix.com>
Subject: Re: Allow signaling a process by all its thread ids?
References: <1242944179.10298.11.camel@odie.local> <20090521235428.53b71862@lxorguk.ukuu.org.uk>
In-Reply-To: <20090521235428.53b71862@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2009 23:11:33.0002 (UTC) FILETIME=[7B314EA0:01C9DA69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> You need to show that
> - The current API breaks stuff
> - The current API is absolutely invalid in posix
> - Changing it improves the functionality and power of the kernel

I think an argument could be made for these.  A task is not necessarily
a process, and kill() is only defined to send a signal to one or more
processes.  This introduces potential problems if a) it is possible to
send a signal to an individual tid, and b) a tid can be reused in a
different process.

We already have the tgkill() syscall, which fixes the ambiguity by
specifying both the pid and tid.  This is what pthread_kill() uses under
the hood.  The fact that it was seen as necessary (back in 2.5)
indicates that there are problems with kill() as currently implemented.

> - Changing it doesn't break existing applications

This last one is the kicker.  As I mentioned in my other reply, I
suspect that making such a change would break a lot of (not-quite-POSIX)
applications that assume they can send a signal to particular threads
using kill().

I see analogies to the whole fsync() issue.

Chris
