Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYJPVfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYJPVfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYJPVfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:35:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:47338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbYJPVfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:35:00 -0400
Subject: Re: tracepoints for kernel/mutex.c
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, compudj@krystal.dyndns.org, fche@redhat.com,
       fweisbec@gmail.com, edwintorok@gmail.com, mingo@elte.hu,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20081016210430.GC25738@redhat.com>
References: <20081016210430.GC25738@redhat.com>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 23:34:38 +0200
Message-Id: <1224192879.16038.82.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 17:04 -0400, Jason Baron wrote:

> Below are 3 tracepoints I've been playing with in kernel/mutex.c using
> a SystemTap script. The idea is to detect and determine the cause of
> lock contention. Currently I get the following output:
> 
> <contended mutex nam> <process name and pid of the contention> <time of
> contention> <pid that woke me up(caused the contention?)>

> I think this approach has a number of advantages. It has low
> overhead in the off case, since its based on tracepoints. It is
> minimally invasive in the code path (3 tracepoints). It also allows me
> to explore data structures and parts of the kernel by simply modifying
> the SystemTap script. I do not need to re-compile the kernel and reboot.

*sigh* this is why I hate markers and all related things...

_IFF_ you want to place tracepoints, get them in the same place as the
lock-dep/stat hooks, that way you get all the locks, not only mutexes.

This is the same reason I absolutely _hate_ Edwin's rwsem tracer.

Folks, lets please start by getting the tracing infrastructure in and
those few high-level trace-points google proposed.

Until we get the basics in, I think I'm going to NAK any and all
tracepoint/marker patches.

