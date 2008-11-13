Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYKMQBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYKMQBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYKMQBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:01:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:53319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYKMQBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:01:09 -0500
Message-ID: <491C4F2C.6000709@kernel.org>
Date: Fri, 14 Nov 2008 01:00:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu> <491C1588.2060907@kernel.org> <E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu> <E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu> <491C2A63.1030804@kernel.org> <E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu> <491C39BD.8050108@kernel.org> <E1L0dUS-00074L-Uz@pomaz-ex.szeredi.hu> <491C436C.6060603@kernel.org> <E1L0eUz-0007D0-Tp@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L0eUz-0007D0-Tp@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 16:00:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
>> * Higher overhead when poll/select finishes.  Either all outstanding
>>   requests need to be cancelled using INTERRUPT whenever poll/select
>>   returns or kernel needs to keep persistent list of outstanding polls
>>   so that later poll/select can reuse them.  The problem here is that
>>   kernel doesn't know when or whether they'll be re-used.  We can put
>>   in LRU-based heuristics but it's getting too complex.
> 
> Why not just link the outstanding poll requests into a list anchored
> in 'fuse_file'?  Easy to reuse, don't care about cancellation.

Ah, that's the right place.

>> Overall, I think being lazy about cancellation and let userland notify
>> asynchronously would be better performance and simplicity wise.  What
>> do you think?
> 
> Lazy cancellation (no cancellation, esentially) sounds good.  But that
> works fine with the simplified protocol.
> 
> Think of it this way, this is what a poll event would look like with
> your scheme:
> 
> 1) -> POLL-notification
> 2) <- POLL-req
> 3) -> POLL-reply (revents)
> 
> Notice, how 1) and 2) don't carry _any_ information (the notification
> can be spurious, the events in the POLL request is just repeated from
> the original request).  All the info is in 3), so I really don't see
> any reason why the above would be better than just omitting the first
> two steps.

Alrighty then.  I'll convert it.

Thanks.

-- 
tejun
