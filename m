Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYGaTij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYGaTij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYGaTia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:38:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50415 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754602AbYGaTi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:38:29 -0400
Date: Thu, 31 Jul 2008 14:38:27 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
Message-Id: <20080731143827.b8bf7bce.pj@sgi.com>
In-Reply-To: <6599ad830807311006r24e4d325ie505949ad760afd@mail.gmail.com>
References: <48912FDD.8060006@cn.fujitsu.com>
	<20080731072355.b582b2d6.pj@sgi.com>
	<4891B9E0.2090900@cn.fujitsu.com>
	<20080731083706.e6bd4acc.pj@sgi.com>
	<6599ad830807311006r24e4d325ie505949ad760afd@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> That loop really could do with some updates though - currently it
> looks at the mm for every task in the cpuset, rather than filtering
> duplicate mms from threaded applications.

Interesting.

After a quick glance, I suppose that we'd still have:
 1) allocate an mmarray[] in that particular loop as we do now,
    sized large enough for all tasks,
 2) convert each task to it's mm, in the next code chunk, with:
	mm = get_task_mm(p);

but that then, before we call "mpol_rebind_mm()" for each such
mm, we could essentially do a "sort -u" (sort unique) on that
mmarray[], to remove duplicate mm's.  This would not change any
of the existing loops; rather just add one more code paragraph,
to remove the duplicate mm's.

Is that what you're thinking, Paul M?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
