Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYETEwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYETEwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYETEwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:52:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYETEwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:52:32 -0400
Date: Tue, 20 May 2008 00:37:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: MA QING A <Qing.a.Ma@alcatel-sbell.com.cn>
cc: Kasper Sandberg <lkml@metanurb.dk>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: RE: 2.6.25.4-rt2
In-Reply-To: <630E9048ECEBBB4798CE33255209FE730648317D@CNSHGSMBS02.ad4.ad.alcatel.com>
Message-ID: <Pine.LNX.4.58.0805200030120.9319@gandalf.stny.rr.com>
References: <1211237032.14697.76.camel@localhost.localdomain><1211239147.198
 45.42.camel@localhost>  <Pine.LNX.4.58.0805191936120.4125@gandalf.stny.rr.com>
 <630E9048ECEBBB4798CE33255209FE730648317D@CNSHGSMBS02.ad4.ad.alcatel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 20 May 2008, MA QING A wrote:

> Forgive me to ask a stupid question.
> Why using the 24 mainline kernel, the time is less than using the
> rt-patched kernel?
>

The test I used is a performance test, not a latency test. An RTOS
(Real-time Operating System) will sacrifice performance to achieve
determinism (low latencies). Several key features to an RT system usually
come with a performance cost.

A non RT system will perform 99% of the time faster than an RTOS. But all
it takes is that one time to miss a deadline to make an RT system crash.
An RTOS may be slightly slower, but it will not have those outliers that a
normal desktop system would have.

So getting back to your question.  Hackbench runs a bunch of stuff and
times how long it took to do so. It stresses the system quite a bit. The
lower the number the better. Given that hackbench is not checking for
latency, but only shear perforance, it is expected that hackbench will run
better on a non RT system.

Now, a test like cyclictest that measures latencies will show the benefits
of realtime.  The kernel with the RT patch can measure 65 microsecond
latencies for response times even while running hackbench. The vanilla
kernel would measure a few milliseconds response times running the same
test.

-- Steve

