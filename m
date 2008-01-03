Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYACWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYACWBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYACWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:01:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYACWBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:01:08 -0500
Date: Thu, 3 Jan 2008 17:00:35 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-ID: <20080103170035.105d22c8@cuia.boston.redhat.com>
In-Reply-To: <1199380412.5295.29.camel@localhost>
References: <20080102224144.885671949@redhat.com>
	<1199379128.5295.21.camel@localhost>
	<20080103120000.1768f220@cuia.boston.redhat.com>
	<1199380412.5295.29.camel@localhost>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jan 2008 12:13:32 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Yes, but the problem, when it occurs, is very awkward.  The system just
> hangs for hours/days spinning on the reverse mapping locks--in both
> page_referenced() and try_to_unmap().  No pages get reclaimed and NO OOM
> kill occurs because we never get that far.  So, I'm not sure I'd call
> any OOM kills resulting from this patch as "false".  The memory is
> effectively nonreclaimable.   Now, I think that your anon pages SEQ
> patch will eliminate the contention in page_referenced[_anon](), but we
> could still hang in try_to_unmap().

I am hoping that Nick's ticket spinlocks will fix this problem.

Would you happen to have any test cases for the above problem that
I could use to reproduce the problem and look for an automatic fix?

Any fix that requires the sysadmin to tune things _just_ right seems
too dangerous to me - especially if a change in the workload can
result in the system doing exactly the wrong thing...

The idea is valid, but it just has to work automagically.

Btw, if page_referenced() is called less, the locks that try_to_unmap()
also takes should get less contention.

-- 
All Rights Reversed
