Return-Path: <linux-kernel-owner+w=401wt.eu-S934839AbXJOUQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934839AbXJOUQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763961AbXJOUQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:16:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbXJOUQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:16:35 -0400
Date: Mon, 15 Oct 2007 16:13:15 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, mingo@elte.hu
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20071015161315.4fe18e07@bree.surriel.com>
In-Reply-To: <20071015114738.6b5a25c7.akpm@linux-foundation.org>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>
	<20071015114738.6b5a25c7.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 11:47:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 15 Oct 2007 10:46:47 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > 
> > Subject: Give kjournald a IOPRIO_CLASS_RT io priority
> > From: Arjan van de Ven <arjan@linux.intel.com>

> Seems a pretty fundamental change which could do with some careful
> benchmarking, methinks.

FWIW, I have marked the kjournald processes on my system
realtime with "rtprio -c 1 `pidof kjournald`" and the
usual desktop stalls that plague my system have not yet
happened this afternoon.

> See, your patch amounts to "do more seeks to improve one test case". 
> Surely other testcases will worsen.  What are they?

The big problem I have seen here is that processes end up
waiting on kjournald to do something, and kjournald is
waiting due to the IO scheduler.

This can cause a lot of low IO (high IO priority) processes
to indirectly get stuck behind a few high IO (low priority)
processes.

Since you have been involved a lot with ext3 development,
which kinds of workloads do you think will show a performance
degradation with Arjan's patch?   What should I test?

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
