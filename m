Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZKITcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZKITcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 14:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZKITcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 14:32:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZKITcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 14:32:24 -0500
Subject: Re: utime/stime decreasing on thread exit
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <20091109192355.GA13724@redhat.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>
	 <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop>
	 <20091109172020.GA7751@redhat.com> <1257787903.4108.345.camel@laptop>
	 <20091109192355.GA13724@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 20:32:23 +0100
Message-ID: <1257795143.4108.375.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 20:23 +0100, Oleg Nesterov wrote:
> On 11/09, Peter Zijlstra wrote:
> >
> > On Mon, 2009-11-09 at 18:20 +0100, Oleg Nesterov wrote:
> >
> > > Stanislaw has already sent the patch, but I don't know what happened
> > > with this patch:
> > >
> > > 	[PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with __exit_signal()
> > > 	http://marc.info/?l=linux-kernel&m=124505545131145
> >
> > That patch has the siglock in the function calling
> > thread_group_cputime(), the 22 code had it near the loop proper, which
> > to me seems a more sensible thing, since there could be more callers,
> > no?
> 
> Well, we can't take ->siglock in thread_group_cputime(), sometimes it
> is called under ->siglock. do_task_stat(), get_cpu_itimer() at least.
> 
> IIRC, Stanislaw verified other callers have no problems with this helper.

Would have made fine changelog material :-)

