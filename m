Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbXJ0VAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbXJ0VAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXJ0U75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:59:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48239 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753236AbXJ0U74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:59:56 -0400
Date: Sat, 27 Oct 2007 13:59:52 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071027135952.2e8fb323.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710271044410.524@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<Pine.LNX.4.64.0710261949360.30293@schroedinger.engr.sgi.com>
	<20071026221624.cec512da.pj@sgi.com>
	<Pine.LNX.4.64.0710262303410.30785@schroedinger.engr.sgi.com>
	<20071027013656.4ffadb87.pj@sgi.com>
	<Pine.LNX.4.64.0710271044410.524@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > You have chosen (1) above, which keeps Choice A as the default.
> 
> There can be different defaults for the user space API via libnuma that 
> are indepdent from the kernel API which needs to remain stable. The kernel 
> API can be extended but not changed.

Yes - the user level code can have different defaults too.

I was discussing what should be the default kernel API.

> None of those [alternatives] sound appealing.  Multiple processes may run
> in one cpuset.

Well, that would justify keeping this choice per-task.  I tend to
agree with that.

But that doesn't justify having to specify it on each system call.

In another reply David recommends against supporting Choice A at all.
I'm inclined to agree with him.  I'll reply there, with more thoughts.

But if we did support Choice A, as a backwards compatible alternative
to Choice B, I'd suggest a per-task mode, not per-system call mode.
This would reduce the impact on the API of the ugly, unobvious, modal
flag needed to select the optional, non kernel default, Choice B
semantics.

I still have low confidence that you (Christoph) and I have the same
understanding of what these Choice A and B are.  Hopefully you can
address that, perhaps by briefly describing these choices in your words.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
