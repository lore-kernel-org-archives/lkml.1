Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYFWKiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYFWKiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYFWKiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:38:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:36422 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYFWKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W1/E9eckYBIN1o/VfxtogZ+lqM2rLGkP2K/mXqZQ5ycltOhAD1MkJ4+A7owwNurH1K
         yEABkvt0rOlcWGB2arcUKynmP1+wvTdMXEcGiKCTPs0vi8WVNRYnOlGGqT7Wc73gvQV4
         e3dw4mbAoH2FVhITpQddeKh2mv0TKu9Uvm+Ak=
Message-ID: <485F7D04.7000609@gmail.com>
Date: Mon, 23 Jun 2008 12:37:56 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Eric Rannaud <eric.rannaud@gmail.com>
CC: Divyesh Shah <dpshah@google.com>, balbir@linux.vnet.ibm.com,
       menage@google.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       matt@bluehost.com, roberto@unbit.it, randy.dunlap@oracle.com,
       akpm@linux-foundation.org
Subject: Re: i/o bandwidth controller infrastructure
References: <20030410181011$6d15@gated-at.bofh.it> <aC1Yl-2AL-1@gated-at.bofh.it> <75b07c02-1595-4af2-ac87-3b067459f62e@w8g2000prd.googlegroups.com> <48D0786A-AC3B-46C3-B35C-EAAA47BFAEBC@google.com> <4856EB9D.6070804@gmail.com> <alpine.LFD.1.10.0806221232070.2247@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0806221232070.2247@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Rannaud wrote:
> On Tue, 17 Jun 2008, Andrea Righi wrote:
>>> With this bandwidth controller, a cpu-intensive job which otherwise  does
>>> not care about its IO
>>> performance needs to be pin-point accurate about IO bandwidth  required in
>>> order to not suffer
>>> from cpu-throttling. IMHO, if a cgroup is exceeding its limit for a  given
>>> resource, the throttling
>>> should be done _only_ for that resource.
>> I understand your point of view. It would be nice if we could just
>> "disable" the i/o for a cgroup that exceeds its limit, instead of
>> scheduling some sleep()s, so the tasks running in this cgroup would be
>> able to continue their non-i/o operations as usual.
>>
>> However, how to do if the tasks continue to perform i/o ops under this
>> condition? we could just cache the i/o in memory and at the same time
>> reduce the i/o priority of those tasks' requests, but this would require
>> a lot of memory, more space in the page cache, and probably could lead
>> to potential OOM conditions. A safer approach IMHO is to force the tasks
>> to wait synchronously on each operation that directly or indirectly
>> generates i/o. The last one is the solution implemented by this
>> bandwidth controller.
> 
> What about AIO? Is this approach going to make the task sleep as well?
> Would it better to return from aio_write()/_read() with EAGAIN?

Good point. I should check, but it seems sleeps are incorrectly
performed also for AIO requests. I agree the correct behaviour would be
to return EAGAIN instead, as you suggested. I'll look at it if nobody
comes up with a solution.

Thanks,
-Andrea
