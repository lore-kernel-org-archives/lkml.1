Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXCWQlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXCWQlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXCWQlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:41:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35592 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbXCWQlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:41:20 -0400
Subject: Re: controlling mmap()'d vs read/write() pages
From: Dave Hansen <hansendc@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, xemul@sw.ru,
       containers@lists.osdl.org, menage@google.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <m1tzwc5kw6.fsf@ebiederm.dsl.xmission.com>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
	 <1173724979.11945.103.camel@localhost.localdomain>
	 <20070312224129.GC21258@MAIL.13thfloor.at>
	 <20070312220439.677b4787.akpm@linux-foundation.org>
	 <1173806793.6680.44.camel@localhost.localdomain>
	 <20070313190931.1417c012@lxorguk.ukuu.org.uk>
	 <m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
	 <1174062660.8184.8.camel@localhost.localdomain>
	 <m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>
	 <1174074412.8184.29.camel@localhost.localdomain>
	 <m1zm6ajvns.fsf@ebiederm.dsl.xmission.com>
	 <1174407335.26166.146.camel@localhost.localdomain>
	 <m13b3zmx4b.fsf@ebiederm.dsl.xmission.com> <46036C54.6030502@yahoo.com.au>
	 <m1tzwc5kw6.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 09:41:12 -0700
Message-Id: <1174668073.8323.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 04:12 -0600, Eric W. Biederman wrote:
> Would any of them work on a system on which every filesystem was on
> ramfs, and there was no swap?  If not then they are not memory attacks
> but I/O attacks.

I truly understand your point here.  But, I don't think this thought
exercise is really helpful here.  In a pure sense, nothing is keeping an
unmapped page cache file in memory, other than the user's prayers.  But,
please don't discount their prayers, it's what they want!

I seem to remember a quote attributed to Alan Cox around OLS time last
year, something about any memory controller being able to be fair, fast,
and accurate.  Please pick any two, but only two.  Alan, did I get
close?

To me, one of the keys of Linux's "global optimizations" is being able
to use any memory globally for its most effective purpose, globally
(please ignore highmem :).  Let's say I have a 1GB container on a
machine that is at least 100% committed.  I mmap() a 1GB file and touch
the entire thing (I never touch it again).  I then go open another 1GB
file and r/w to it until the end of time.  I'm at or below my RSS limit,
but that 1GB of RAM could surely be better used for the second file.
How do we do this if we only account for a user's RSS?  Does this fit
into Alan's unfair bucket? ;)

Also, in a practical sense, it is also a *LOT* easier to describe to a
customer that they're getting 1GB of RAM than >=20GB/hr of bandwidth
from the disk.  

-- Dave

P.S. Do we have an quotas on ramfs?  If we have an ramfs filesystems,
what keeps the containerized users from just filling up RAM?

