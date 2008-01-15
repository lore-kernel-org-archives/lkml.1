Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYAOC5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYAOC5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYAOC5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:57:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbYAOC5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:57:00 -0500
Date: Mon, 14 Jan 2008 21:56:47 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-ID: <20080114215647.169fd245@bree.surriel.com>
In-Reply-To: <20080115110918.118B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115111035.d516639a.kamezawa.hiroyu@jp.fujitsu.com>
	<20080115110918.118B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 11:20:56 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Kame
> 
> > > +	if (pressure) {
> > > +		nr_wakeup = max_t(int, atomic_read(&nr_watcher_task)>>4, 100);
> > > +		atomic_long_set(&last_mem_notify, jiffies);
> > > +		wake_up_locked_nr(&mem_wait, nr_wakeup);
> > > +	}
> > What is this for ? and Why ?
> > Are there too many waiters ?
> 
> my intent is for avoid thundering herd.
> 100 is heuristic value.
> 
> and too many wakeup cause too much memory freed.
> I don't want it.
> 
> of course, if any problem happened, I will change.

I agree with you.  Your code looks like it could be a reasonable
heuristic, but the only way to really find that out is to test
the code on live systems under varying workloads.

Maybe we need to wake up fewer tasks more often, maybe we are
better off waking up more tasks but fewer times.  Either way,
at this time we simply do not know and can stick with your current 
code.

-- 
All rights reversed.
