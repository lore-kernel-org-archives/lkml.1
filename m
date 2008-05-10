Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYEJTST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYEJTST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 15:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYEJTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 15:18:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:25908 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYEJTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 15:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Bck9H1VUZtOUQRHtwEu0yf6cMrNkYKsxFHVjstFLbvWNZRE0Kj+uYb2hxry/LW1JuvraXg46S1HIbjpNNk2FdLDQ2JG7ORVe21C6WhwXKgcRjt1p3wbB42BIOUsveqZNbtu6ieM7tN4DBOYGMPlOOyz15mxtUTijN1N30lOnNEI=
Message-ID: <e85b9d30805101218u4b8f0c2bw47af2384133a5c77@mail.gmail.com>
Date: Sat, 10 May 2008 21:18:04 +0200
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, hi everybody,

I've encountered sort of a performance "regression" in using cfq (and
the cfq-based bfq) in comparison with the other io-schedulers:

1) interactivity during load is much better compared to the others
(thanks a lot for that, that made me appreciate this scheduler) BUT
2) everything seems to take somewhat longer to load (big applications
like firefox, etc. )
3) hdparm shows the same behavior

since I've started using cfq only for a few days (approx. 1-2 weeks
now) I didn't really notice it until I tested "performance" via
hdparm:


/dev/sdd:
 Timing buffered disk reads:  308 MB in  3.01 seconds = 102.22 MB/sec

/dev/sdd:
 Timing buffered disk reads:  306 MB in  3.01 seconds = 101.66 MB/sec

/dev/sdd:
 Timing buffered disk reads:  304 MB in  3.02 seconds = 100.77 MB/sec
noop [anticipatory] deadline cfq

deadline & noop are similar, the test of noop finishes pretty fast ...


/dev/sdd:
 Timing buffered disk reads:  170 MB in  3.02 seconds =  56.27 MB/sec

/dev/sdd:
 Timing buffered disk reads:  176 MB in  3.02 seconds =  58.21 MB/sec

/dev/sdd:
 Timing buffered disk reads:  176 MB in  3.02 seconds =  58.22 MB/sec
noop anticipatory deadline [cfq]

this behavior occurs on an jmicron sata-controller (JMB363/361) and
the probably the 4th port of the Intel ICH7R but only with cfq
selected, the first (?) and second (?) port of the Intel ICH7R are
fine performance-wise, don't know why it's that picky
with the other schedulers it's fine

I've tested: 2.6.24-gentoo-r7 (+ 2.6.24.7), 2.6.24-gentoo-r3, 2.6.25,
2.6.25.2 (+ 2.6.25-zen1), 2.6.25-rc8, the kernel of the ubuntu
desktop-livecd amd64 (ubuntu 8.04) (cfq enabled)
all show this worse "performance" compared to the other schedulers
all kernels are amd64 on gentoo ~amd64, glibc-2.7.1, gcc-4.2.3 hardened

hardware:
Asus P5W DH Deluxe

I unfortuantely can't test earlier kernel-versions due to the fact
that I'm using reiser4 for /(root) and the earlier kernels + reiser4
aren't that stable in terms of data safety

hopefully this is reproducable & you guys can explain if this is
something to "worry" about (performance) and/or a real regression or
just some kind of placebo effect

Many thanks in advance & thanks a lot for this great scheduler (cfq;
I'm looking forward to bfq in mainline which seems to work even better
under load)

Regards

Mat
