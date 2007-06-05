Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbXFEXB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbXFEXB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932769AbXFEXBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:01:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44626 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764775AbXFEXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:01:48 -0400
Date: Tue, 5 Jun 2007 16:01:49 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@cthulhu.engr.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
Message-Id: <20070605160149.348b5c4a.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OOM-killed tasks, marked as TIF_MEMDIE, should not be able to access 
> memory outside its cpuset because it could potentially cause other 
> exclusive cpusets to OOM themselves.

I'm a little surprised at this suggested change -- I'd have thought
that it was a good idea to let tasks marked for extinction get memory
anywhere, as they were going to use that memory to exit, and free up
lots more memory.

I'm pretty sure we have this same policy in other places in the
kernel, besides cpusets.  Did you intend to change them too?

If a MEMDIE task is taking enough memory to OOM other tasks anywhere
in the system, then doesn't that mean your entire system was in deep
yogurt, and we're just haggling over who to blame for the upcoming
crash?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
