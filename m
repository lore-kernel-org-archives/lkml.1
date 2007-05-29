Return-Path: <linux-kernel-owner+w=401wt.eu-S1765492AbXE2Ube@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765492AbXE2Ube (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbXE2Ub1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:31:27 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:40075 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759158AbXE2Ub0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:31:26 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070529130107.112347096@chello.nl>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
Content-Type: text/plain
Date: Tue, 29 May 2007 13:28:45 -0700
Message-Id: <1180470525.32594.71.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 14:52 +0200, Peter Zijlstra wrote:
> +       now = sched_clock();
> +       waittime = now - hlock->waittime_stamp;
> + 

It looks like your using sched_clock() through out .. It's a little
troubling considering the constraints on the function .. Most
architecture implement a jiffies sched_clock() w/ 1 millisecond or worse
resolution.. I'd imagine a millisecond hold time is pretty rare, even a
millisecond wait time might be fairly rare too ..  There's also no
guarantee that sched_clock timestamps off two different cpu's can be
compared (or at least that's my understanding) ..

Daniel

