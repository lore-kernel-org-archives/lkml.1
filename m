Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbZK2SCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbZK2SCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 13:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZK2SCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 13:02:19 -0500
Received: from mail2.racsa.co.cr ([196.40.31.26]:33309 "EHLO
	barracuda7.racsa.co.cr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZK2SCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 13:02:19 -0500
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Nov 2009 13:02:18 EST
X-ASG-Debug-ID: 1259516818-63c5031f0000-xx1T2L
X-Barracuda-URL: http://172.16.1.16:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: osobosque@racsa.co.cr
Date: Sun, 29 Nov 2009 11:46:43 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: futex_cmpxchg_enabled not set in futex_init on pentium3
Subject: futex_cmpxchg_enabled not set in futex_init on pentium3
Message-id: <alpine.LNX.2.00.0911291057100.2912@bruno>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Barracuda-Connect: UNKNOWN[172.16.7.14]
X-Barracuda-Start-Time: 1259516818
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at racsa.co.cr
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=4.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=6.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.15900
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all:

Sometime between 2.6.28.6 and 2.6.31.5 a regression (feature?) in the futex
system now causes futex test failures on glibc-2.9 which where not present
before.  That is, recompiling the binaries of glibc-2.9 and rerunning its
test suite now produces futex errors that passed previously.  The problem
appears now with glibc-2.9 compiled with either gcc-4.1.2 or gcc-4.4.2, and
with glibc-2.11 compiled with gcc-4.4.2, which is what I am currently
running on this machine, failures and all.

The system under discussion is a uniprocessor pentium3 with an AMI BIOS. 
Full details available on request should that prove necessary.

I have tracked the test failures down to the fact that futex_cmpxchg_enabled
is not set because the test in futex_init now "fails" (actually succeeds). 
This appears to be happening because the expected page fault intentionally
provoked by a null dereference appears to be working now in kernel mode. 
This *may* (rank speculation) be associated with the AMI BIOS low-memory
corruption protection added sometime during this gap, and which is activated
on this machine.

Before I muck any further with this, especially involving the quite tricky
futex mess, I would appreciate some insight into the idea behind the test in
futex_init.  I don't understand why you would bother to invoke a fault in
what is apparently a test to determine if the cmpxchg instruction works. 
The fault is supposed to occur as a result of a null dereference that takes
place *before* the cmpxchg instruction is even executed.  If you want to
test that cmpxchg works, why not just make a little test in futex_init that
uses it and fails (not succeeds) if it doesn't behave as expected, or if
there is a fault of some kind (like illegal instruction)?  Or is the fact
that we don't get a fault the whole point here?


Regards,

Joseph

Please CC me directly as I am no longer subscribed to the list.
