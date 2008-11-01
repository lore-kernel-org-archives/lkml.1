Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbYKAQOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbYKAQOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYKAQOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:14:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3771 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751586AbYKAQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:14:43 -0400
Date: Sat, 1 Nov 2008 12:14:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: (BUG?) round_jiffies() is non-monotonic on SMP
Message-ID: <Pine.LNX.4.44L0.0811011205030.21703-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it generally recognized that round_jiffies() can be non-monotonic on 
SMP systems?  By this, I mean that if cpu-a and cpu-b respectively do:

	ra = round_jiffies(ja);

		and

	rb = round_jiffies(jb);

then the ordering of ra and rb can be opposite the ordering of ja and 
jb.

If this is known, is it regarded as a potential problem?  It certainly
seems likely that some code somewhere depends on timeouts expiring in
the correct order.

Alan Stern

P.S.: As a related matter, it seems very odd that we don't have a 
round_jiffies_up() routine.  Surely there are plenty of places where it 
doesn't matter if an event is a little late but where the event must 
not be early.  (I know two such places offhand.)  Any objection to 
having one added?

