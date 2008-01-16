Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYAPCaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYAPCaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbYAPCah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:30:37 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:56096 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbYAPCag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:30:36 -0500
Date: Tue, 15 Jan 2008 21:29:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Rowand, Frank" <frank.rowand@us.sony.com>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: RE: [PATCH] lost softirq, 2.6.24-rc7
In-Reply-To: <884020C16A0AFF4D8A8B7800EA0C98870FD5F6@ussdixms03.am.sony.com>
Message-ID: <Pine.LNX.4.58.0801152126110.19680@gandalf.stny.rr.com>
References: <1200435326.4092.9.camel@bx740> <20080116003946.GE30532@goodmis.org>
 <884020C16A0AFF4D8A8B7800EA0C98870FD5F6@ussdixms03.am.sony.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Jan 2008, Rowand, Frank wrote:

>
> Steve,
>
> You are totally correct.  I used the wrong words when I said
> "ksoftirqd thread runs".  My apologies for very misleading wording.
>
> I have updated the wording in-line below, in the original message to
> indicate that it is softirq threads, in the ksoftirqd() function, not
> the ksoftirqd thread.

Actually, it's the fact that the code you show runs in ___do_softirq().
In full PREEMPT_RT, that should never happen.

Well, there is one case that that code can run. It's when hardirqs and
softirqs have the same prio, and the hardirq is bound to a single CPU.
But we've had so much trouble with running softirqs from hardirq threads,
that I've disabled it for -rt3.

I'll be (hopefully) releasing -rt3 tonight. I'm not including this patch
because it should never hit those code paths. But feel free to complain if
you still see this issue, and it goes away with the patch. Actually, I've
been thinking of adding a

#ifdef CONFIG_PREEMPT_RT
	WARN_ON(1);
#endif

at the start of ___do_softirq();

-- Steve
