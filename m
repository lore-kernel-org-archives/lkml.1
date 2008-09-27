Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbYI0GRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbYI0GRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 02:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYI0GRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 02:17:34 -0400
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:36808
	"EHLO QMTA06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbYI0GRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 02:17:33 -0400
X-Authority-Analysis: v=1.0 c=1 a=Dd6PgZL8iy0A:10 a=2ifrMIwaUIwA:10
 a=TaNns3-9mCtvS2EAcScA:9 a=7m6-oOLJ4c5jvup43T4A:7
 a=z6h9OBOswDN_v6dzRo6T28s7aTAA:4 a=b8hG5vVbyAkA:10
Subject: [RFC PATCH 0/10] relay revamp, third installment
From: Tom Zanussi <zanussi@comcast.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Content-Type: text/plain
Date: Sat, 27 Sep 2008 01:17:41 -0500
Message-Id: <1222496261.6710.71.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the current relay cleanup patchset.

1-2 make the write path completely replaceable.
3 adds flags along with some related cleanup.
4-8 remove the padding in several stages.

The new patches in this set are:

9 simplifies the callbacks - now that we have flags, the subbuf_start
callback is much simpler, has been combined with notify_consumers and
has been renamed new_subbuf.  Because part of the simplification has
been to handle buffer-full conditions and count lost events internally,
normal applications don't have to pay attention to it at all.

10 completely removes the idea of sub-buffers completely and now deals
only with pages. relay_open() channges accordingly - buffer sizes are
now in pages and consumers are woken only every n_wakeup pages, or never
if this is 0. 

It's a work in progress, but because I wanted the intermediate stages to
actually work and not break anything, some of these patches, especially
05, are just temporary and will be removed in the next iteration.

I didn't have time to clean up the first 3 either - I'll also do that
the next time around.

In the next round I plan to do vmap removal.

Tom

