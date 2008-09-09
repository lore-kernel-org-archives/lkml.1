Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYIIQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYIIQIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYIIQI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:08:26 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51189 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbYIIQIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:08:25 -0400
Date: Tue, 9 Sep 2008 20:13:45 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frank Mayhar <fmayhar@google.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
Message-ID: <20080909161345.GA742@tv-sign.ru>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com> <20080909070329.GD2086@elte.hu> <20080909160152.GA714@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909160152.GA714@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Oleg Nesterov wrote:
>
> So, the first CLONE_THREAD creates ->cputime.totals. After that
> thread_group_cputime_account_xxx() start to use it even if the task
> doesn't have the attached cpu timers.
>
> Stupid question: can't we allocate .totals in posix_cpu_timer_create() /
> set_process_cpu_timer() ?

Just to clarify: yes I see, .totals is also used by do_task_stat()/etc,
but they can iterate over sub-threads as before.

And my apologies if this was already discussed ;)

Oleg.

