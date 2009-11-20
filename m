Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZKTIkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZKTIkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZKTIkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:40:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:56190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZKTIkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:40:35 -0500
Message-ID: <4B065616.8070304@kernel.org>
Date: Fri, 20 Nov 2009 17:40:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net
Subject: Re: [PATCH 15/19] workqueue: kill cpu_populated_map
References: <1258692407-8985-1-git-send-email-tj@kernel.org> <1258692407-8985-16-git-send-email-tj@kernel.org>
In-Reply-To: <1258692407-8985-16-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/20/2009 01:46 PM, Tejun Heo wrote:
> Single threaded workqueue is scheduled to be reimplemented in the near
> future.  Kill cpu_populated_map and make single threaded workqueues
> behave more like multi threaded ones - all cwqs are initialized and
> all workqueues are linked on the workqueues list.  This will ease
> further changes.
> 
> While at it, make get_cwq() always return the cwq for the specified
> cpu, add target_cwq() for cases where single thread distinction is
> necessary and drop all direct usage of per_cpu_ptr() on wq->cpu_wq.

This one was incorrect in that it may leak a thread when offline is is
brought up for the first time.  I'll repost 15-19 along with more prep
patches.

Thanks.

-- 
tejun
