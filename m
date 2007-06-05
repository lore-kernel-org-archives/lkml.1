Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbXFEXc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbXFEXc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbXFEXcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:32:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46149 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758553AbXFEXct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:32:49 -0400
Date: Tue, 5 Jun 2007 16:32:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, David Rientjes wrote:

> > But the alternative is that the exiting process does not save its 
> > data.
> The same condition that occurs when there is a system-wide OOM, yes.  
> Exclusive cpusets cannot be violated for such allocations outside of the 
> obvious GFP_ATOMIC exception.

But with the patch the process would be able to terminate. There is no 
global OOM situation. If there would be a global OOM situation then 
TIF_MEMDIE would not help.

> > What is this very small exclusive cpuset?
> That's arbitrary.  The idea is that an exclusive cpuset should not 
> encounter memory pressure because another exclusive cpuset encountered an 
> OOM condition because its zones happened to be higher on the zonelist.  
> Notice how, without this change, it's possible to allocate on a node 
> outside our mems_allowed before we use our own memory reserves.

So its seems that the patch is addressing an imagined situation?

I think the allocation outside of our mems_allowed is fine when it serves 
to terminate the process and thereby release resources. It is certainly 
better than having the process corrupt data by only partially writing back 
its data.


