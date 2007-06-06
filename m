Return-Path: <linux-kernel-owner+w=401wt.eu-S933893AbXFFBc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbXFFBc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758510AbXFFBcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:32:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51896 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761085AbXFFBcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:32:51 -0400
Date: Tue, 5 Jun 2007 18:32:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <alpine.DEB.0.99.0706051817380.23799@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0706051826310.6928@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051653330.6473@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051817380.23799@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, David Rientjes wrote:

> Obviously GFP_KERNEL allocations can allocate regardless of our memory 
> exclusivity, but the point is that a job in one exclusive cpuset should 
> not have the ability to effect the performance (in terms of reclaim and 
> swap), memory usage, or survival of jobs in other exclusive cpusets 
> because it was out of memory.

Right but the process is terminating thus only requiring limited resources
to get finished. The process does not have the ability to affect the other 
cpusets. I.e. it cannot directly allocate outside of the cpuset. The 
system has that capability and the system is handling the termination of 
the process and should terminate the process in a clean way if possible.

> > Processes stuck in D state is another issue with reliability.
> But it's a reality that we need to respect.  It happens and when it does
> it has the potential to hamper other cpusets that we setup to be exclusive 
> themselves.

The fact that process hang because of some software deficiency is an 
exceptional failure scenario. The system in general is not fully 
operational anymore anyways. Typically one or the other lock is held which 
makes certain kernel functionality inaccessible.

