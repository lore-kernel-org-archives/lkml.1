Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZKBP4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZKBP4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZKBP4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:56:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:36182 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755333AbZKBP4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:56:03 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+K2slxbRSKrvkMVZKY9j8/2VYvdET3y0vyzuCEr1
	rZ3bdFhqMXl3nI
Subject: Re: [Bug 12309] Large I/O operations result in slow performance
 and high iowait times
From: Mike Galbraith <efault@gmx.de>
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091101134207.b97e4f5f.akpm@linux-foundation.org>
References: <20091101134207.b97e4f5f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 16:56:04 +0100
Message-Id: <1257177364.10173.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --- Comment #412 from Thomas Pilarski <thomas.pi@arcor.de>  2009-11-01 21:28:24 ---
> Created an attachment (id=23618)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=23618)
> Simple sleeper test case
> 
> As this bug occurs more permanent while working in an virtual machine or while
> using java and I still think, that's this is a process scheduler bug (or
> something related). Here another test case, which shows the suspected
> behaviour. As there are many system calls while using a virtual machine, I have
> tries to find an equal test. The test case just sleeps for 1__s and measures the
> time difference of the usleep operation. I am using such many of the usleep
> operations, as the problems does not occur deterministic and I tried to catch
> as many as possibly occurrences. 
> 
> I have run this test case on three machines. The first one was a Core2 Duo with
> a first generation SDD (OCZ Core Series) with a poor write performance and on a
> Ubuntu kernel 2.6.31-14-generic. The partitions are block aligned. I have run
> this test, while my wife was using firefox. Every time, she was submitting
> something and firefox is using sqlite for writing the history, there was a high
> latency for the sleep test.
> 
> Timediff    7629094:   16.80ms Total:  61.12ms
> Timediff    7629100:   18.82ms Total:  93.68ms
> Timediff    7629101:   19.96ms Total: 113.54ms
> Timediff    7629102:   19.98ms Total: 133.43ms
> Timediff    7629103:   19.97ms Total: 153.31ms
> Timediff    7629104:   20.00ms Total: 173.24ms
> Timediff    7629105:   19.96ms Total: 193.09ms
> Timediff    7629106:   20.02ms Total: 213.02ms
> Timediff    7629107:   19.94ms Total: 232.86ms
> Timediff    7636162:   16.40ms Total:  34.44ms
> Timediff    7636164:   19.90ms Total:  64.00ms
> 
> While the duration of 100 usleep should be somewhere between 10ms and 20ms, 10
> usleep(1) takes more than 200ms. This behaviour is reproducible. 

Can you please try the latest -rc?  I spent the day trying to coax a
latency spike out of -tip, including thumping disk with dd, mysql+oltp
rw test et al, and failed.

	-Mike

