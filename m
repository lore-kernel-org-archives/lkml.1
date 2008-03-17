Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYCQQ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYCQQ53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYCQQ5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:57:22 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41841 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYCQQ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:57:21 -0400
Date: Mon, 17 Mar 2008 20:01:24 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] kill_pid_info: don't take now unneeded tasklist_lock
Message-ID: <20080317170124.GA115@tv-sign.ru>
References: <20080304185745.GA8482@tv-sign.ru> <47DE5665.2030802@bk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DE5665.2030802@bk.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Atsushi Tsuji wrote:
>
> (2008/03/05 3:57), Oleg Nesterov wrote:
> >Previously handle_stop_signal(SIGCONT) could drop ->siglock. That is why
> >kill_pid_info(SIGCONT) takes tasklist_lock to make sure the target task
> >can't go away after unlock. Not needed now.
> >
> >Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> Hi Oleg,
> 
> I tried your patches on vanila kernel 2.6.25-rc3 (ia64).  Then, I got
> the NULL pointer dereference at task_session_nr(t) in
> check_kill_permission(). That is why t->signal->__session is accessed
> after t->signal was released.  It is reproducible by sending many
> SIGCONT signals to exiting processes.

Ah. Indeed!!! Thanks a lot Atsushi.

Note that check_kill_permission() is the last user of the deprecated
signal->__session/session, I was going to change this code later, but
missed the issue you pointed out.

I'll make the patch tomorrow.

Thanks!

Oleg.

