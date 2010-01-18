Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920Ab0ARKOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0ARKOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 05:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135Ab0ARKOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 05:14:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:33878 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0ARKOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 05:14:47 -0500
Subject: Re: [PATCH 01/40] sched: consult online mask instead of active in
 select_fallback_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <1263776272-382-2-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 11:13:40 +0100
Message-ID: <1263809620.4283.173.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
> If called after sched_class chooses a CPU which isn't in a task's
> cpus_allowed mask,

I can only see this happening when you're changing cpus_allowed after
starting to take down the cpu. IOW you're moving a thread to a dying
cpu.

This is because you're spawning workqueue threads while we're going
down?



