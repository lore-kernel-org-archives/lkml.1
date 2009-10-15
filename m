Return-Path: <linux-kernel-owner+w=401wt.eu-S935337AbZJOUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935337AbZJOUq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZJOUq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:46:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:54090 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbZJOUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:46:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=XbboK+ggbdziO8HReFjViYU1MpTXZDUJyhdXSd+Ge9gksJAr71UsiWW6+bUFgbdXm
	vu2DFefavU/l7KlTSATmQ==
Date: Thu, 15 Oct 2009 13:45:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frans Pop <elendil@planet.nl>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <200910151642.05276.elendil@planet.nl>
Message-ID: <alpine.DEB.1.00.0910151339370.17578@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910150143.18755.elendil@planet.nl> <20091015090301.GC10546@elte.hu> <200910151642.05276.elendil@planet.nl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Frans Pop wrote:

> You simply cannot distinguish between "extra vanilla kernel commits" 
> and "distro commits" in a tree. Both are changes since the tagged release; 
> both will trigger the "+", which makes the "+" meaningless.
> 

I can guarantee that distro is not going to be releasing a "v2.6.33" 
kernel with patches on top of it without modifying the version string in 
some way.  With my patch, the `+' is suppressed when LOCALVERSION= is 
used.

I chose not to allow CONFIG_LOCALVERSION to suppress the `+' because the 
config normally does not change with a revision, a build does.  So while 
CONFIG_LOCALVERSION may describe the packager of the kernel, LOCALVERSION= 
would describe a particular release.

> > Besides, distros building on kernels inbetween -rc's is very rare.
> 
> True. Which is why we shouldn't be adding the "+".
> 

The `+' is irrelevant at -rc releases, it wouldn't be added anyway!  It's 
purpose is to identify non-vanilla release kernels.

> But that's the whole point. It does not!
> Even if they _only_ add their packaging infrastructure on top and have no 
> patches that affect the the kernel itself (which is unlikely), they would 
> still end up with the "+" because the commit(s) that add the packaging 
> infrastructure make the tree unequal to the tagged release.
> 

Why would you add packaging infrastructure to the kernel source itself?  
Normally you would have a Makefile for rpm packaging that would call into 
the kernel Makefile, leaving it vanilla.
