Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325Ab0ARJqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0ARJqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541Ab0ARJqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:46:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab0ARJqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:46:01 -0500
Subject: Re: [PATCH 39/40] gfs2: use workqueue instead of slow-work
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <1263776272-382-40-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-40-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 18 Jan 2010 09:45:59 +0000
Message-ID: <1263807959.2715.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
> Workqueue can now handle high concurrency.  Use system_long_wq instead
> of slow-work.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steven Whitehouse <swhiteho@redhat.com>

Acked-by: Steven Whitehouse <swhiteho@redhat.com> on two conditions:

 i) That scheduling work on this new workqueue will not require any
GFP_KERNEL allocations (even hidden ones such as starting new threads)
before the work runs. This is required since the recovery code must not
call into the fs until after its recovered.
ii) That there is no interaction between this workqueue and the
"delayed" workqueue which the glock code uses since the recovery must
not block that workqueue, nor must that workqueue block recovery.

Having read briefly through the other patches, I believe that both those
two conditions are met, but I thought I'd ask too, just to be on the
safe side. Otherwise it looks like a nice clean up,

Steve.


