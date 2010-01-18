Return-Path: <linux-kernel-owner+w=401wt.eu-S1751401Ab0ARFhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab0ARFhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 00:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714Ab0ARFhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 00:37:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:55634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0ARFhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 00:37:17 -0500
Message-ID: <4B53F496.8050105@kernel.org>
Date: Mon, 18 Jan 2010 14:41:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 30/40] workqueue: implement work_busy()
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-31-git-send-email-tj@kernel.org> <1263783156.5220.66.camel@palomino.walls.org>
In-Reply-To: <1263783156.5220.66.camel@palomino.walls.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 05:35:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andy.

On 01/18/2010 11:52 AM, Andy Walls wrote:
>>From a driver writer's perspective, this function not useful since it is
> unreliable (false positives only?) and I have no way of
> 
> "ensuring the workqueue @work was last queued on stays valid until this
> function returns."
> 
> I don't quite know how to check and enfore a workqueue's continuing
> validity across the function call.  (Maybe you could clarify?)

I don't really think that would be possible without tinkering with
workqueue internal locking.

> 2. Just schedule the work object and check the return value to see if
> the submission suceeded.  If it did, the work was "not pending".  This
> method can't check for "running" of course.

For workqueue, the above combined with proper subsystem locking would
be the best way to do it, I think.

> Is there some specific use case where this function is very useful
> despite being unreliable?  I just think it's asking for abuse by someone
> who would think "mostly reliable" is good enough, when it actually may
> not be.

I mostly just wanted to keep the fscache debug printout which
indicates whether a fscache object has work pending or running.  It's
a debug printout so it doesn't need to be reliable.  If the debug
printout can be removed, this patch can go too.

Thanks.

-- 
tejun
