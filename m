Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZG1CTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZG1CTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 22:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZG1CTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 22:19:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZG1CTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 22:19:48 -0400
Date: Mon, 27 Jul 2009 22:19:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add walltime support for ring-buffer
In-Reply-To: <20090728015351.GF5147@nowhere>
Message-ID: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>
References: <4A698F90.90501@cn.fujitsu.com> <alpine.DEB.2.00.0907240902030.17438@gandalf.stny.rr.com> <20090728103227.D7FB.A69D9226@jp.fujitsu.com> <20090728015351.GF5147@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Jul 2009, Frederic Weisbecker wrote:
> > 
> > In nowadays, many workload run on cluster machine environment. Then
> > We often need compare different machines tracing log. it mean TSC isn't
> > sufficient. but nobody want performance reduce.
> > Fortunatelly, ntp time adjustment is not happend so frequently. we
> > don't need wall-time on _every_ event.
> > 
> > Thanks.
> 
> 
> Yeah, that would really slow the tracing.
> 
> Can't we get a snapshot of the couple (walltime, cpu clock) once
> at startup.
> Then we can retrieve the walltime when cpu_clock was 0 and compute
> the walltime for each traces at output time using the trace timestamp as
> a delta?

This should be something in one of the trace clock sources. It can perhaps 
have a helper function called by gettimeofday or something, but it should 
be something that gets plugged into the ring buffer and not something that 
needs to modify any of its code.

-- Steve

