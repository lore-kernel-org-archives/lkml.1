Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXD1IDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXD1IDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXD1IDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:03:50 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36169 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXD1IDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:03:47 -0400
Date: Sat, 28 Apr 2007 10:01:00 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Roland Dreier <rdreier@cisco.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
In-Reply-To: <adak5vxm459.fsf@cisco.com>
Message-ID: <Pine.LNX.4.61.0704280956190.506@yvahk01.tjqt.qr>
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org>
 <20070425112133.4ae86399.randy.dunlap@oracle.com>
 <20070425143011.57247c1d.akpm@linux-foundation.org>
 <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com>
 <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org>
 <20070428030805.GA13331@redhat.com> <20070427221803.2a117c23.akpm@linux-foundation.org>
 <adak5vxm459.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27 2007 22:58, Roland Dreier wrote:
>
>--- checkpatch.pl.orig	2007-04-27 20:30:34.000000000 -0700
>+++ checkpatch.pl	2007-04-27 22:54:42.000000000 -0700
>@@ -123,7 +123,7 @@
> 	$warnings += search(qr/kernel_thread\(/, "Use kthread abstraction instead of kernel_thread()\n");
> 	$warnings += search(qr/typedef/, "Do not add new typedefs.\n");
> 	$warnings += search(qr/uint32_t/, "Incorrect type usage for kernel code. Use __u32 etc.\n");
>-	$warnings += search(qr/BUG(_ON)\(/, "Use WARN_ON & Recovery code rather than BUG() and BUG_ON()\n");
>+	$warnings += search(qr/(?<!BUILD_)BUG(_ON)\(/, "Use WARN_ON & Recovery code rather than BUG() and BUG_ON()\n");

I wonder what the capture is for?
 (?<!BUILD_)BUG(?:_ON) if you ask me :)
But you could also use...
 qr/\bBUG_ON\(/
which rules out a BUILD_BUG_ON, because _ does not constitute a word 
boundary, since _ is in \w.

And since when is uint32_t wrong? What makes u32 or __u32 better?
We have sprintf, (k)asprintf, abs(), etc. etc. etc. tons of functions
named similar to their ISO C counterparts, but when it comes to types,
we make an exception?


Jan
-- 
