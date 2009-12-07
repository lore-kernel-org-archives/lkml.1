Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbZLGKjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbZLGKjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZLGKjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:39:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:58098 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbZLGKjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:39:53 -0500
Message-ID: <4B1CDB83.2000600@kernel.org>
Date: Mon, 07 Dec 2009 19:40:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
Subject: Re: [PATCH 16/19] workqueue: reimplement workqueue flushing using
 color coded works
References: <1258692407-8985-1-git-send-email-tj@kernel.org>	 <1258692407-8985-17-git-send-email-tj@kernel.org>	 <1259927181.17907.98.camel@laptop>  <4B196610.7090101@kernel.org> <1260175562.8223.1204.camel@laptop>
In-Reply-To: <1260175562.8223.1204.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/07/2009 05:46 PM, Peter Zijlstra wrote:
> A sudden influx of high prio worklets would hold back the completion of
> existing worklets, so simply waiting for a particular colour to deplete
> is going to last a long while.
> 
> The barrier semantics I implemented ensured worklets couldn't cross a
> barrier, so if a high prio item got stuck behind a barrier it would
> simply elevate the priority of everything before the barrier, and would
> complete everything before that barrier before running itself.
> 
> This insures progress and thereby guarantees completion of flushes.

Hmmm... I haven't really thought about priority aware implementation
but if we're gonna do that with global shared workers, the logical way
to do it would be to have separate workers with higher priority so
that the prioritizing and starvation prevention can be handled by the
schduler as it does for all other tasks.  What kind of priorities are
we talking about?  How granual?

Thanks.

-- 
tejun
