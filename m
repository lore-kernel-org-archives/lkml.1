Return-Path: <linux-kernel-owner+w=401wt.eu-S1751377AbXCDBEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbXCDBEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXCDBEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:04:09 -0500
Received: from tomts41.bellnexxia.net ([209.226.175.98]:57469 "EHLO
	tomts41-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbXCDBEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:04:08 -0500
X-Greylist: delayed 2944 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Mar 2007 20:04:07 EST
Subject: Re: userspace pagecache management tool
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070303122935.f1ab0067.akpm@linux-foundation.org>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 19:14:59 -0500
Message-Id: <1172967299.8493.34.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-03 at 12:29 -0800, Andrew Morton wrote:


> There is much more which could be done to make this code smarter, but I
> think the lesson here is that we can produce a far, far better result doing
> this work in userspace than we could ever hope to do with an in-kernel
> implementation.  There are some enhancement suggestions in the
> documentation file.

While I think that more user space applications should use fadvise() to
avoid polluting the page cache with unneeded data, I still think the
kernel should be more fair in regard to page cache management.

Personally, I've experienced some sluggish performance after copying
large files around. Even more when using NFS. It's difficult to file a
bug report for "interactive feel", I don't know how to measure it. I
just feel it's a weak aspect of the OS.

Surely it's possible to make the kernel a little bit better to protect
the page cache from abuse, from simple or badly designed applications.

Why fairness is provided by the process scheduler with good results, yet
it somewhat easy for a process to cause slowdowns from page cache usage.

My personal opinion is that the VM seem tuned for database types
workloads. Of course, making the page cache more fair to prevent one
process to use most of it will most likely slowdown database type
applications.

Maybe the situation should be reversed, much like the process scheduler.
Fairness by default, and the possibility to request for more system
resources by asking for them with necessary privileges. Much like
SCHED_FIFO policy.


- Eric



