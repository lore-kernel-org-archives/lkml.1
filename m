Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbXFEXzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbXFEXzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934142AbXFEXzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:55:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47100 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934119AbXFEXzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:55:38 -0400
Date: Tue, 5 Jun 2007 16:55:38 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
Message-Id: <20070605165538.0a3ce6fe.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	<20070605160149.348b5c4a.pj@sgi.com>
	<alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
	<alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
	<alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If that fails, we can't allocate elsewhere because then we have taken 
> exclusive memory from other applications and is contrary to the definition 
> of mem_exclusive. 

Well, I can't speak to the 'real' meaning of TIF_MEMDIE with authority,
but I can speak to the meaning of cpuset flags.

The mem_exclusive flag doesn't mean this.

It means that you cannot overlap the memory of a sibling cpuset.

You will, necessarily, still overlap the memory of your ancestor cpusets.

Whether or not you make any use of the mem_exclusive flag, you still
get the same (limited) guarantees of memory usage -- namely that your
memory won't be used by tasks in non-overlapping cpusets, with some
exceptions, such as:
 1) memory handed out to interrupt code,
 2) memory handed out for GFP_ATOMIC requests, and
 3) tasks marked PF_EXITING -- will soon free up memory

Tasks in cpusets ancestor to your tasks cpuset can always, easily,
use memory on the same nodes your task is on.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
