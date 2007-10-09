Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXJISPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXJISPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbXJISO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:14:58 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:37042 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXJISO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:14:57 -0400
Date: Tue, 9 Oct 2007 14:14:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, kravetz@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, pmorreale@novell.com,
       sdietrich@novell.com
Subject: Re: [RFC PATCH RT] push waiting rt tasks to cpus with lower prios.
In-Reply-To: <1191952777.23198.8.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0710091413290.23629@gandalf.stny.rr.com>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net> 
 <Pine.LNX.4.58.0710091054430.21404@gandalf.stny.rr.com> 
 <1191944024.4281.72.camel@ghaskins-t60p.haskins.net>
 <1191952777.23198.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Tue, 9 Oct 2007, Steven Rostedt wrote:

> This has been complied tested (and no more ;-)
>
>
> The idea here is when we find a situation that we just scheduled in an
> RT task and we either pushed a lesser RT task away or more than one RT
> task was scheduled on this CPU before scheduling occurred.
>
> The answer that this patch does is to do a O(n) search of CPUs for the
> CPU with the lowest prio task running. When that CPU is found the next
> highest RT task is pushed to that CPU.

I don't want that O(n) to scare anyone. It really is a O(1) but with a
K = NR_CPUS. I was saying if you grow the NR_CPUS the search grows too.

-- Steve

