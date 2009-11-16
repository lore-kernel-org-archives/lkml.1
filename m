Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZKPSzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZKPSzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZKPSzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:55:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:39186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbZKPSzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:55:35 -0500
Message-ID: <4B019FC9.4080309@kernel.org>
Date: Tue, 17 Nov 2009 03:54:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, andi@firstfloor.org,
       fweisbec@gmail.com
Subject: Re: [PATCH 04/21] sched: implement scheduler notifiers
References: <1258391726-30264-1-git-send-email-tj@kernel.org>	 <1258391726-30264-5-git-send-email-tj@kernel.org> <1258396864.4372.55.camel@twins>
In-Reply-To: <1258396864.4372.55.camel@twins>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> I really hate exposing activate/deactivate.
> 
> You say:
> 
>> Activated and deactivated are called
>> when a task's readiness to run changes.
> 
> How is that not clear from the out hook? It would seem to me that when
> you get scheduled out with a p->state != TASK_RUNNING you're not ready.

In that in OUT hook the next task to switch to is already determined
and it wouldn't be symmetric with activate (but I suppose we can match
the symmetry from activate side).  If deactivate/activate/in/out
events are too low level, we can have sleep/ready/run hooks instead.

Thanks.

-- 
tejun
