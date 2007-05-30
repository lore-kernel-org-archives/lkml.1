Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXE3NTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXE3NTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXE3NTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:19:31 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:58757 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751871AbXE3NTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:19:30 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1180470525.32594.71.camel@imap.mvista.com>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 15:03:26 +0200
Message-Id: <1180530206.7348.83.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 13:28 -0700, Daniel Walker wrote:
> On Tue, 2007-05-29 at 14:52 +0200, Peter Zijlstra wrote:
> > +       now = sched_clock();
> > +       waittime = now - hlock->waittime_stamp;
> > + 
> 
> It looks like your using sched_clock() through out .. It's a little
> troubling considering the constraints on the function .. Most
> architecture implement a jiffies sched_clock() w/ 1 millisecond or worse
> resolution.. I'd imagine a millisecond hold time is pretty rare, even a
> millisecond wait time might be fairly rare too ..  There's also no
> guarantee that sched_clock timestamps off two different cpu's can be
> compared (or at least that's my understanding) ..

All valid points, however.. calling anything more expensive 2-3 times
per lock acquisition is going to be _very_ painful.

Also, IMHO the contention count vs the acquisition count is the most
interesting number, the times are just a nice bonus (if and when they
work).


