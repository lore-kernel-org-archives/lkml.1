Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYITOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYITOhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYITOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:37:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55171 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYITOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:37:29 -0400
Date: Sat, 20 Sep 2008 10:37:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sitsofe Wheeler <sitsofe@yahoo.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       astarikovskiy@suse.de
Subject: Re: Reading EeePC900 battery info causes stalls (was Re: How how  
 latent should non-preemptive scheduling be?)
In-Reply-To: <48D50498.5050608@yahoo.com>
Message-ID: <alpine.DEB.1.10.0809201037070.13540@gandalf.stny.rr.com>
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no>
 <48D4CC1B.7030708@yahoo.com> <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com> <48D50498.5050608@yahoo.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008, Sitsofe Wheeler wrote:

> Steven Rostedt wrote:
> > The wake up tracing is CONFIG_SCHED_TRACER. If you do not see "wakeup" as
> > one of the available tracers in available_tracers, then check
> > your dmesg and see if you have CONFIG_FTRACE_STARTUP_TEST enabled. There was
> > a known bug that would cause the wakeup tracing to fail the test. When a
> > trace fails the startup test, it is disabled.
> 
> This is exactly the case (dmesg reports the ftrace wakeup startup test
> failed). That's what I get for not reading my dmesg more carefully...

OK, that is probably the known bug you are hitting. Simply disable the 
CONFIG_FTRACE_STARTUP_TEST and you should have the wakeup tracer. The bug 
is with the test, not the tracer, so it should not hurt you.

-- Steve

