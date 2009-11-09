Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZKIT3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZKIT3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 14:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZKIT3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 14:29:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbZKIT3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 14:29:17 -0500
Date: Mon, 9 Nov 2009 20:23:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: utime/stime decreasing on thread exit
Message-ID: <20091109192355.GA13724@redhat.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com> <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <20091109172020.GA7751@redhat.com> <1257787903.4108.345.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257787903.4108.345.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Peter Zijlstra wrote:
>
> On Mon, 2009-11-09 at 18:20 +0100, Oleg Nesterov wrote:
>
> > Stanislaw has already sent the patch, but I don't know what happened
> > with this patch:
> >
> > 	[PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with __exit_signal()
> > 	http://marc.info/?l=linux-kernel&m=124505545131145
>
> That patch has the siglock in the function calling
> thread_group_cputime(), the 22 code had it near the loop proper, which
> to me seems a more sensible thing, since there could be more callers,
> no?

Well, we can't take ->siglock in thread_group_cputime(), sometimes it
is called under ->siglock. do_task_stat(), get_cpu_itimer() at least.

IIRC, Stanislaw verified other callers have no problems with this helper.

Oleg.

