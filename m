Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbXD1AvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbXD1AvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbXD1AvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:51:08 -0400
Received: from ozlabs.org ([203.10.76.45]:39797 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973AbXD1AvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:51:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17970.39536.345559.867146@cargo.ozlabs.ibm.com>
Date: Sat, 28 Apr 2007 10:50:56 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	<200704280041.17617.rjw@sisk.pl>
	<alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
	<200704280145.26253.rjw@sisk.pl>
	<alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> I really don't see how you can say that stopping threads etc can make any 
> difference what-so-ever. If you don't create the snapshot with interrupts 
> disabled (and just with a single CPU running) you have so many other 
> problems that it's not even remotely funny.

I agree.  I don't like the freezer.  We have had working
kernel-controlled suspend to RAM on powerbooks for almost 10 years
now, and we never needed to freeze processes.

That said, I can see two attractions in freezing processes:

1. It provides a way to stop new I/O requests coming in, and thus
   somewhat makes up for the lack of a way to freeze device request
   queues (at least, we didn't have one last time I looked).

2. Systems do sometimes die while suspended (e.g. run out of battery,
   or the resume process fails), and to make the next boot painless,
   you want the filesystems on disk to be as clean as possible.
   Freezing processes and then doing a sync provides one way to
   achieve that.  Of course, you have to make sure you don't freeze
   any kernel threads that are needed for doing the sync...  And if
   one of your filesystems is using FUSE, it's not going to get very
   far.

Paul.
