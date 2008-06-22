Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYFVTmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYFVTmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYFVTlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:41:55 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64151 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYFVTly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uWvjQH8M5bgiEWS5BV3tbfvCjfBL0bxBgB4JKncwiwi9aSG50v621jh6hKoSUlWm+H
         R7tYc8RXD1g2aTjF+Ff4IDw90zJHFL+u69Hsvx8YKu+G8cXCtSt34oqGDSXbYgcDYht1
         7Xh1F9lKMr9FTtFR+GIAMbAx/txVKMs3f44Kg=
Date: Sun, 22 Jun 2008 12:41:48 -0700 (PDT)
From: Eric Rannaud <eric.rannaud@gmail.com>
X-X-Sender: e@localhost.localdomain
To: Andrea Righi <righi.andrea@gmail.com>
cc: Divyesh Shah <dpshah@google.com>, balbir@linux.vnet.ibm.com,
       menage@google.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       matt@bluehost.com, roberto@unbit.it, randy.dunlap@oracle.com,
       akpm@linux-foundation.org
Subject: Re: i/o bandwidth controller infrastructure
In-Reply-To: <4856EB9D.6070804@gmail.com>
Message-ID: <alpine.LFD.1.10.0806221232070.2247@localhost.localdomain>
References: <20030410181011$6d15@gated-at.bofh.it> <aC1Yl-2AL-1@gated-at.bofh.it> <75b07c02-1595-4af2-ac87-3b067459f62e@w8g2000prd.googlegroups.com> <48D0786A-AC3B-46C3-B35C-EAAA47BFAEBC@google.com> <4856EB9D.6070804@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, Andrea Righi wrote:
> > With this bandwidth controller, a cpu-intensive job which otherwise  does
> > not care about its IO
> > performance needs to be pin-point accurate about IO bandwidth  required in
> > order to not suffer
> > from cpu-throttling. IMHO, if a cgroup is exceeding its limit for a  given
> > resource, the throttling
> > should be done _only_ for that resource.
> 
> I understand your point of view. It would be nice if we could just
> "disable" the i/o for a cgroup that exceeds its limit, instead of
> scheduling some sleep()s, so the tasks running in this cgroup would be
> able to continue their non-i/o operations as usual.
> 
> However, how to do if the tasks continue to perform i/o ops under this
> condition? we could just cache the i/o in memory and at the same time
> reduce the i/o priority of those tasks' requests, but this would require
> a lot of memory, more space in the page cache, and probably could lead
> to potential OOM conditions. A safer approach IMHO is to force the tasks
> to wait synchronously on each operation that directly or indirectly
> generates i/o. The last one is the solution implemented by this
> bandwidth controller.

What about AIO? Is this approach going to make the task sleep as well?
Would it better to return from aio_write()/_read() with EAGAIN?

Thanks.
