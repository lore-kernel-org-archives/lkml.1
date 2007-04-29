Return-Path: <linux-kernel-owner+w=401wt.eu-S1161556AbXD2XcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161556AbXD2XcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161558AbXD2XcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:32:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36712 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161556AbXD2XcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:32:03 -0400
Date: Sun, 29 Apr 2007 16:35:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070429163532.2d52e4e2.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0704280956190.506@yvahk01.tjqt.qr>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
	<adak5vxm459.fsf@cisco.com>
	<Pine.LNX.4.61.0704280956190.506@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 10:01:00 +0200 (MEST) Jan Engelhardt wrote:

> 
> On Apr 27 2007 22:58, Roland Dreier wrote:
> >
> >--- checkpatch.pl.orig	2007-04-27 20:30:34.000000000 -0700
> >+++ checkpatch.pl	2007-04-27 22:54:42.000000000 -0700
> >@@ -123,7 +123,7 @@
> > 	$warnings += search(qr/kernel_thread\(/, "Use kthread abstraction instead of kernel_thread()\n");
> > 	$warnings += search(qr/typedef/, "Do not add new typedefs.\n");
> > 	$warnings += search(qr/uint32_t/, "Incorrect type usage for kernel code. Use __u32 etc.\n");
> >-	$warnings += search(qr/BUG(_ON)\(/, "Use WARN_ON & Recovery code rather than BUG() and BUG_ON()\n");
> >+	$warnings += search(qr/(?<!BUILD_)BUG(_ON)\(/, "Use WARN_ON & Recovery code rather than BUG() and BUG_ON()\n");
> 
> I wonder what the capture is for?
>  (?<!BUILD_)BUG(?:_ON) if you ask me :)
> But you could also use...
>  qr/\bBUG_ON\(/
> which rules out a BUILD_BUG_ON, because _ does not constitute a word 
> boundary, since _ is in \w.

Ack, I added \b.  Thanks.

> And since when is uint32_t wrong? What makes u32 or __u32 better?
> We have sprintf, (k)asprintf, abs(), etc. etc. etc. tons of functions
> named similar to their ISO C counterparts, but when it comes to types,
> we make an exception?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
