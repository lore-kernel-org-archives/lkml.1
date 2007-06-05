Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbXFEXQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbXFEXQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765291AbXFEXQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:16:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763290AbXFEXQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:16:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=I8nVhGT7VCYApXV5+CIhqpypX40HW1/B64L+8s8gDhqzRFtruAq1VDrbHvpWJ1VR4
	Z18/mF/m/lcusM4IPs6Xg==
Date: Tue, 5 Jun 2007 16:16:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, ak@suse.de, clameter@cthulhu.engr.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <20070605160149.348b5c4a.pj@sgi.com>
Message-ID: <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Paul Jackson wrote:

> I'm a little surprised at this suggested change -- I'd have thought
> that it was a good idea to let tasks marked for extinction get memory
> anywhere, as they were going to use that memory to exit, and free up
> lots more memory.
> 

The intended purpose of TIF_MEMDIE was to allocate pages without being 
bound by the watermarks so that they have access to memory reserves on the 
per-zone level.  If the cpuset doesn't have access to a zone, whether it's 
memory reserve or not, it shouldn't allocate there.

> I'm pretty sure we have this same policy in other places in the
> kernel, besides cpusets.  Did you intend to change them too?
> 

You'd have to cite them first.

> If a MEMDIE task is taking enough memory to OOM other tasks anywhere
> in the system, then doesn't that mean your entire system was in deep
> yogurt, and we're just haggling over who to blame for the upcoming
> crash?
> 

No, it means that it can allocate anywhere based on the zonelist ordering 
and then can OOM a very small exclusive cpuset that would never have had 
any memory pressure if it wasn't violated.

		David
