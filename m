Return-Path: <linux-kernel-owner+w=401wt.eu-S934814AbYBUQt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934814AbYBUQt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766015AbYBUQtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:49:00 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:52984 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765495AbYBUQs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:48:58 -0500
Date: Thu, 21 Feb 2008 11:48:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 10/14] adjust pi_lock usage in wakeup
In-Reply-To: <20080221152717.4804.56212.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0802211147270.11610@gandalf.stny.rr.com>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
 <20080221152717.4804.56212.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Feb 2008, Gregory Haskins wrote:

> From: Peter W.Morreale <pmorreale@novell.com>
>
> In wakeup_next_waiter(), we take the pi_lock, and then find out whether
> we have another waiter to add to the pending owner.  We can reduce
> contention on the pi_lock for the pending owner if we first obtain the
> pointer to the next waiter outside of the pi_lock.
>
> This patch adds a measureable increase in throughput.

I see how this may decrease contention (slightly less time in holding the
pi_lock). But, please, when stating something like: "adds a measurable
increase in throughput", show the benchmark numbers.

-- Steve

