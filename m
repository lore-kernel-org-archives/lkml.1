Return-Path: <linux-kernel-owner+w=401wt.eu-S934233AbXFEX5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233AbXFEX5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760653AbXFEX5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:57:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47909 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764804AbXFEX5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:57:31 -0400
Date: Tue, 5 Jun 2007 16:57:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0706051653330.6473@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, David Rientjes wrote:

> If that fails, we can't allocate elsewhere because then we have taken 
> exclusive memory from other applications and is contrary to the definition 
> of mem_exclusive.  You need to construct your cpuset hierarchy with these 
> scenarios in mind; when you ask for an exclusive cpuset, it shouldn't come 
> with a disclaimer that says "if another cpuset that is also exclusive 
> happens to OOM, we'll steal your memory anyway and it's not our problem if 
> the dying task gets stuck in D state and doesn't exit synchronously or 
> reliably because all we did was send it a SIGKILL."

Exclusive is not as absolute as you may think. There is also the 
GFP_KERNEL exception.

Processes stuck in D state is another issue with reliability.

> > So its seems that the patch is addressing an imagined situation?
> No, it's returning us to the previous logic where an exclusive cpuset was 
> actually exclusive.
> 
> And, again, without this change it is possible to allocate in other 
> exclusive cpusets without first exhausting your own memory reserves.  
> That's wrong.

That is already occurring with GFP_KERNEL. So your patch really does not 
have the purifying effect on exclusivity that you expect. This looks all 
more like hunting for elusive idealistic cpuset behavior to me.

