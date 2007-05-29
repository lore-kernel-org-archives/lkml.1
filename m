Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbXE3Giw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbXE3Giw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 02:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXE3Gid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 02:38:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:10071 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXE3Gib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 02:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jhejqxK9SKMp2YtetcN1iHBSCJlEDKZlpoJlVQwAe1EUdCYi24VI3M48RlL/OL4HES1Q8fny12aEIYtLNRzk2GDQX2Rd2oydzvL4mc2uOy7jXqLeXl2j/nRn0ahI0bX42KUwIbfCwaTXIbXKQB8fCFZK+7t1AB1kG8mUrWt2bW4=
Message-ID: <465C809C.60507@gmail.com>
Date: Wed, 30 May 2007 04:35:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: davids@webmaster.com
CC: linux-kernel@vger.kernel.org
Subject: Re: epoll,threading
References: <MDEHLPKNGKAHNMBLJOLKGEJIEBAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEJIEBAC.davids@webmaster.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>> I want to know in detail about , what the events (epoll or /dev/poll or
>> select ) achieve in contrast to  thread per client.
>>
>> i can have a thread per client and use send and recv system call directly
>> right? Why do i go for these event mechanisms?
>>
>> Please help me to understand this.
> 
> Aside from the obvious, consider a server that needs to do a little bit of
> work on each of 1,000 clients on a single CPU system. With a
> thread-per-client approach, 1,000 context switches will be needed. With an
> epoll thread pool approach, none are needed and five or six are typical.
> 
> Both get you the major advantages of threading. You can take full advantage
> of multiple CPUs. You can write code that blocks occasionally without
> bringing the whole server down. A page fault doesn't stall your whole
> server.

It all depends on the workload but thread switching overhead can be
negligible - after all all it does is entering kernel, schedule, swap
processor context and return.  Maybe using separate stack has minor
impact on cache hit ratio.  You need benchmark numbers to claim one way
or the other.

In my experience with web caches, epoll or similar for idle clients and
thread per active client scaled and performed pretty well - it needed
more memory but the performance wasn't worse than asynchronous design
and doing complex server in async model is a lot of pain.

-- 
tejun

