Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbZB0Kqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbZB0Kqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZB0Kq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:46:29 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:43180 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbZB0Kq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:46:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FEcRdmFp0JdzLCH/gWNAyZqCR/7vK5EREO+8z9TZMuy8z2DRIhTw2DzORD5hvDMJNl
         M2CvVpRaFZeTIoF+DYdtDPnSAF4ePG2+S4adByYLDMSBn8QUwGz0tuYrAhFukTC1zZyf
         6SwHtXccqdbqeHeCA49YIXEvwJOzN0BgYDBMA=
Date: Fri, 27 Feb 2009 13:53:06 +0300
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
Message-ID: <20090227105306.GB2939@x200.localdomain>
References: <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu> <1235673016.5877.62.camel@bahia> <20090226221709.GA2924@x200.localdomain> <1235726349.4570.7.camel@bahia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235726349.4570.7.camel@bahia>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 10:19:09AM +0100, Greg Kurz wrote:
> On Fri, 2009-02-27 at 01:17 +0300, Alexey Dobriyan wrote:
> > On Thu, Feb 26, 2009 at 07:30:16PM +0100, Greg Kurz wrote:
> > > On Thu, 2009-02-26 at 18:33 +0100, Ingo Molnar wrote:
> > > > I think the main question is: will we ever find ourselves in the 
> > > > future saying that "C/R sucks, nobody but a small minority uses 
> > > > it, wish we had never merged it"? I think the likelyhood of that 
> > > > is very low. I think the current OpenVZ stuff already looks very 
> > > 
> > > We've been maintaining for some years now a C/R middleware with only a
> > > few hooks in the kernel. Our strategy is to leverage existing kernel
> > > paths as they do most of the work right.
> > > 
> > > Most of the checkpoint is performed from userspace, using regular
> > > syscalls in a signal handler or /proc parsing. Restart is a bit trickier
> > > and needs some kernel support to bypass syscall checks and enforce a
> > > specific id for a resource. At the end, we support C/R and live
> > > migration of networking apps (websphere application server for example).
> > > 
> > > >From our experience, we can tell:
> > > 
> > > Pros: mostly not-so-tricky userland code, independent from kernel
> > > internals
> > > Cons: sub-optimal for some resources
> > 
> > How do you restore struct task_struct::did_exec ?
> 
> With sys_execve().

How do you restore set of uts_namespace's? Kernel never exposes to
userspace which are the same, which are independent.
