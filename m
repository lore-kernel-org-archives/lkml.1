Return-Path: <linux-kernel-owner+w=401wt.eu-S935400AbYEBR2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400AbYEBR2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935136AbYEBR1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:27:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53837 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935048AbYEBR1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:27:35 -0400
Date: Fri, 2 May 2008 21:28:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Petr Tesarik <ptesarik@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: CPU POSIX timers livelock
Message-ID: <20080502172803.GA1541@tv-sign.ru>
References: <1209740741.15210.49.camel@elijah.suse.cz> <20080502152126.GA3130@atjola.homenet> <1209744785.15210.52.camel@elijah.suse.cz> <20080502164334.GA3585@atjola.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502164334.GA3585@atjola.homenet>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02, Bj?rn Steinbrink wrote:
>
> Hm, I have some message in that thread from April they don't seem to be
> on lkml.org nor in the bugzilla though. Oh well, I can send you an mbox
> of that thread in a private mail, just let me know if you want that.

Me too please ;)

Please note there is a related problem if we have a single thread but
a lot of timers attached to this thread. If the signal is ignored, each
timer should be re-armed, this all can consume >= 1/HZ CPU time.
We have "maxfire = 20" in check_thread_timers/check_process_timers to
prevent this, but it is just a workaround. And it is a bit silly to just
waste the CPU if the signal is ignored, arm_timer() is heavy and doesn't
scale well.

However, I have already forgot this code, perhaps I missed something,
and at least maxfire does help.

Oleg.

