Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYETFAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYETFAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 01:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYETFAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 01:00:01 -0400
Received: from cnrelay03.alcatel-sbell.com.cn ([211.144.215.19]:45871 "EHLO
	mail.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751423AbYETFAA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 01:00:00 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset=gb2312
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: 2.6.25.4-rt2
Date: Tue, 20 May 2008 12:59:19 +0800
Message-ID: <630E9048ECEBBB4798CE33255209FE7306483561@CNSHGSMBS02.ad4.ad.alcatel.com>
In-Reply-To: <Pine.LNX.4.58.0805200030120.9319@gandalf.stny.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25.4-rt2
Thread-Index: Aci6M9dIu9AJQlrxQK+wIWqGRhA6CgAALc3Q
References: <1211237032.14697.76.camel@localhost.localdomain><1211239147.198
	45.42.camel@localhost>  
	<Pine.LNX.4.58.0805191936120.4125@gandalf.stny.rr.com><630E9048ECEBBB4798CE
	33255209FE730648317D@CNSHGSMBS02.ad4.ad.alcatel.com> 
	<Pine.LNX.4.58.0805200030120.9319@gandalf.stny.rr.com>
From: "MA QING A" <Qing.a.Ma@alcatel-sbell.com.cn>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Kasper Sandberg" <lkml@metanurb.dk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "RT" <linux-rt-users@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 20 May 2008 04:59:17.0373 (UTC) 
	FILETIME=[41B96AD0:01C8BA36]
X-imss-version: 2.050
X-imss-result: Passed
X-imss-approveListMatch: *@alcatel-sbell.com.cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks very much for your explanation
At the very beginning I thought the Hackbench was a latency tools, so I was very surprised to see such result.

But there's another question. When I choose the Complete Preemption -Real Time  configuration, it's recommended to choose Timer Frequency ---> 1000Mhz to improve the cpu performance, does it mean cpu will cost much more during the thread context switch? Or I should choose 100Mhz in order to decrease the thread context switch and get a better performance? 
Which one should I choose? Or any useful tools can tell me the differences.

Any opinion appreciated
Thanks


Really Thanks again

-----Original Message-----
From: Steven Rostedt [mailto:rostedt@goodmis.org] 
Sent: 2008Äê5ÔÂ20ÈÕ 12:37
To: MA QING A
Cc: Kasper Sandberg; LKML; RT; Ingo Molnar; Thomas Gleixner
Subject: RE: 2.6.25.4-rt2




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

