Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZLUJYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZLUJYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZLUJYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:24:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:42695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZLUJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:24:23 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <4B2EE5A5.2030208@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 10:22:57 +0100
Message-ID: <1261387377.4314.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 12:04 +0900, Tejun Heo wrote:
> When IO goes wrong, in extreme
> cases, it can easily take over thirty secs to recover and that's
> required by the hardware specifications, so anything which ends up
> waiting on IO can take a pretty long time.  The only piece of code
> which is necessary to support that is the code necessary to migrate
> back tasks to CPUs when they come online again.  It's not a lot of
> ugly code. 

Why does it need to get migrated back, there are no affinity promises if
you allow hotplug to continue, so it might as well complete and continue
on the other cpu.

And yes, it is a lot of very ugly code.

