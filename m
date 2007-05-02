Return-Path: <linux-kernel-owner+w=401wt.eu-S1161717AbXEBHZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161717AbXEBHZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161746AbXEBHZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:25:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47205 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161717AbXEBHZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:25:40 -0400
Date: Wed, 2 May 2007 00:25:38 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: rientjes@google.com, torvalds@linux-foundation.org,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: allow empty {cpus,mems}_allowed to be set for
 unpopulated cpuset
Message-Id: <20070502002538.a863bf95.pj@sgi.com>
In-Reply-To: <6599ad830705012036g21cc8470nff246e146b1e4023@mail.gmail.com>
References: <Pine.LNX.4.64.0705011714490.6376@chino.kir.corp.google.com>
	<20070501202201.6903d922.pj@sgi.com>
	<6599ad830705012036g21cc8470nff246e146b1e4023@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Otherwise the only way to reclaim
> the node for a different sibling is to delete the cpuset.

Ah - I just made sense of that sentence.

It means that if a particular memory node is in one cpuset, and you'd
like to have it in another cpuset instead, then with the existing
kernel code, you had to special case the situation where this memory
node was the last node in the original cpuset - deleting the cpuset
just to do this.

Yeah - I have never given much thought to moving memory nodes from one
cpuset to another.  No good reason; it just didn't happen to be a
common operation for the uses of cpusets I cared about.

I still have this niggling fear that there was something that passed my
view, years ago, that this proposed change (to allow unpopulating a
cpuset) will break.

But I'll be damned if I can remember what it was.

Ok ... if this patch passes my cpuset_test (guess I'll try that now)
then I'm ok with this patch.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
