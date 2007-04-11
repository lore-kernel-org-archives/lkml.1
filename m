Return-Path: <linux-kernel-owner+w=401wt.eu-S1161143AbXDKDbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143AbXDKDbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161149AbXDKDbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:31:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52653 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161143AbXDKDbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:31:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] make kernel threads invisible to /sbin/init
References: <20070410185133.GA104@tv-sign.ru>
	<20070410231604.GA19852@vino.hallyn.com>
Date: Tue, 10 Apr 2007 21:29:11 -0600
In-Reply-To: <20070410231604.GA19852@vino.hallyn.com> (Serge E. Hallyn's
	message of "Tue, 10 Apr 2007 18:16:04 -0500")
Message-ID: <m17isjwpvc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Oleg Nesterov (oleg@tv-sign.ru):
>> 1. rename reparent_to_init() to reparent_kthread() and export it
>> 
>> 2. use init_pid_ns.child_reaper instead of child_reaper(current)
>
> Each of these patches looks good to me, but this part in particular
> is a must-have bugfix.

Removing daemonize is a must have bug fix.  This falls short of that so
it is a good fix, but it doesn't solve the core problem that kernel daemons
are being assigned pids inside of child pid namespaces.

It doesn't solve the problem that some kernel daemons are using signals
to communicate with user space.

It doesn't solve the problem that we have to do a lot of massaging and
maintenance to get kernel threads from grabbing references to namespaces
and other kernel pieces they should not be grabbing.

Eric
