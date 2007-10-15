Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXJOVla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXJOVla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXJOVlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:41:23 -0400
Received: from mx-outbound02.utstar.com ([203.193.54.71]:42666 "EHLO
	hk-mail2.utstar.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753858AbXJOVlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:41:22 -0400
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 17:41:21 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Problem:  CPU sleep when calling a function in another object for the first time.
Date: Tue, 16 Oct 2007 05:11:07 +0800
Message-ID: <E9FB75D95739914DBDEDC1867C740F4FD4E64C@ITLHZEXCH01.us.utstar.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Problem:  CPU sleep when calling a function in another object for the first time.
Thread-Index: AcgPb+cpq9QQvri3RNinmYleLBLcog==
From: "John Marconi" <john.marconi@utstar.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been seeing a problem in which one of my CPUs goes to sleep for
40ms in the middle of running a user-space program.  The problem occurs
when I have a function in object file X call another function in object
file Y.  If I add a gettimeofday right before the function call occurs,
and then also right at the beginning of the called function, I see a
40ms delay.  This only occurs on the first call to any function in file
Y.  Once a function in file Y is called, all other calls to functions in
this file are immediate.

I have added a kernel profiler to the timer interrupt of this CPU - and
find that during this 40ms period, the CPU is in r4k_wait - which looks
like cpu_idle is running.  It almost seems like file Y is being loaded
into memory to be used.

The program in question is using pthreads and each thread is on a
separate CPU.  Each CPU is dedicated to running a single thread and
nothing else.  The files X and Y are two object files linked into a
single ELF binary.  The kernel version is 2.6.14 and this is a MIPS
based processor.

Does anyone have any ideas why this delay might be occurring?

Thank you in advance,
John
