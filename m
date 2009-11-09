Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbZKIRbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbZKIRbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZKIRbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:31:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:48436 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZKIRbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:31:47 -0500
Subject: Re: utime/stime decreasing on thread exit
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091109172020.GA7751@redhat.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>
	 <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop>
	 <20091109172020.GA7751@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 18:31:43 +0100
Message-ID: <1257787903.4108.345.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 18:20 +0100, Oleg Nesterov wrote:

> > I just checked .22 and there we seem to hold p->sighand->siglock over
> > the full task iteration.
> 
> Yes. Then thread_group_cputime() was changed so that it didn't itearate
> over sub-threads, then this callsite was move outside of ->siglock, now
> it does while_each_thread() again.
> 
> > So we might as well revert back to that if
> > people really mind counting things twice :-)
> 
> Stanislaw has already sent the patch, but I don't know what happened
> with this patch:
> 
> 	[PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with __exit_signal()
> 	http://marc.info/?l=linux-kernel&m=124505545131145

That patch has the siglock in the function calling
thread_group_cputime(), the 22 code had it near the loop proper, which
to me seems a more sensible thing, since there could be more callers,
no?

