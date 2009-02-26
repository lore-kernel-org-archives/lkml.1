Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbZBZWKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbZBZWKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZBZWKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:10:32 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:51215 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZBZWKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:10:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l6lvtEMQmleWAhG2E4Ok+X5z1ikTbKLcXRFN8UxzcZDaWzCQPWJ4uFykZ1uikf6NJh
         0SU/ZIKs1Jyrax7pkLl3bQGi+RKAa+IVwXWIyW/W4l1CUfodCM/kdtZzmFodWfsrqkWU
         ejmbIauibWSh0HxdbLqO97nGDYxTA+IaPBFpA=
Date: Fri, 27 Feb 2009 01:17:09 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090226221709.GA2924@x200.localdomain>
References: <20090211141434.dfa1d079.akpm@linux-foundation.org> <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu> <1235673016.5877.62.camel@bahia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235673016.5877.62.camel@bahia>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 07:30:16PM +0100, Greg Kurz wrote:
> On Thu, 2009-02-26 at 18:33 +0100, Ingo Molnar wrote:
> > I think the main question is: will we ever find ourselves in the 
> > future saying that "C/R sucks, nobody but a small minority uses 
> > it, wish we had never merged it"? I think the likelyhood of that 
> > is very low. I think the current OpenVZ stuff already looks very 
> 
> We've been maintaining for some years now a C/R middleware with only a
> few hooks in the kernel. Our strategy is to leverage existing kernel
> paths as they do most of the work right.
> 
> Most of the checkpoint is performed from userspace, using regular
> syscalls in a signal handler or /proc parsing. Restart is a bit trickier
> and needs some kernel support to bypass syscall checks and enforce a
> specific id for a resource. At the end, we support C/R and live
> migration of networking apps (websphere application server for example).
> 
> >From our experience, we can tell:
> 
> Pros: mostly not-so-tricky userland code, independent from kernel
> internals
> Cons: sub-optimal for some resources

How do you restore struct task_struct::did_exec ?
