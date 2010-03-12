Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab0CLWyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:54:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:47940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab0CLWyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:54:09 -0500
Message-ID: <4B9AC657.1090607@kernel.org>
Date: Sat, 13 Mar 2010 07:55:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org, oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
References: <4B99CB0F.1090505@kernel.org> <1267187000-18791-1-git-send-email-tj@kernel.org> <29029.1268232771@redhat.com> <3491.1268393035@redhat.com>
In-Reply-To: <3491.1268393035@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Mar 2010 22:52:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/12/2010 08:23 PM, David Howells wrote:
>> Yes, that's the one of the characteristics of workqueue.  For IO bound
>> stuff, it usually is a plus.
> 
> Hmmm.  So when, say, an FS-Cache index object finishes creating
> itself on disk and then releases all the several thousand data
> objects waiting on that event so that they can then create
> themselves, it will do this by calling queue_work() on each of them
> in turn.  I take it this will stack them all up on that one CPU's
> work queue.

Well, you can RR queue them but in general I don't think things like
that would be much of a problem for IO bounded works.  If it becomes
bad, scheduler will end up moving the source around and for most
common cases, those group queued works are gonna hit similar code
paths over and over again during their short CPU burn durations so
it's likely to be more efficient.  Are you seeing maleffects of cpu
affine work scheduling during fscache load tests?

Thank you for testing.

-- 
tejun
