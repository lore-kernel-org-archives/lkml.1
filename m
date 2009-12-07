Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbZLGKnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbZLGKnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZLGKnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:43:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbZLGKnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:43:21 -0500
Subject: Re: [PATCH 16/19] workqueue: reimplement workqueue flushing using
 color coded works
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
In-Reply-To: <4B1CDB83.2000600@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
	 <1258692407-8985-17-git-send-email-tj@kernel.org>
	 <1259927181.17907.98.camel@laptop>  <4B196610.7090101@kernel.org>
	 <1260175562.8223.1204.camel@laptop>  <4B1CDB83.2000600@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 11:42:29 +0100
Message-ID: <1260182549.8223.1463.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 19:40 +0900, Tejun Heo wrote:
> Hello,
> 
> On 12/07/2009 05:46 PM, Peter Zijlstra wrote:
> > A sudden influx of high prio worklets would hold back the completion of
> > existing worklets, so simply waiting for a particular colour to deplete
> > is going to last a long while.
> > 
> > The barrier semantics I implemented ensured worklets couldn't cross a
> > barrier, so if a high prio item got stuck behind a barrier it would
> > simply elevate the priority of everything before the barrier, and would
> > complete everything before that barrier before running itself.
> > 
> > This insures progress and thereby guarantees completion of flushes.
> 
> Hmmm... I haven't really thought about priority aware implementation
> but if we're gonna do that with global shared workers, the logical way
> to do it would be to have separate workers with higher priority so
> that the prioritizing and starvation prevention can be handled by the
> schduler as it does for all other tasks.  What kind of priorities are
> we talking about?  How granual?

Currently the normal 140 priority ones.

