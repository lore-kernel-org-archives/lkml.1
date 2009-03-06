Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZCFPKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZCFPKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZCFPJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:09:51 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:41830 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZCFPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:09:51 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Greg Kurz <gkurz@fr.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305220044.GA2819@x200.localdomain>
References: <20090305163857.0C18F3FD@kernel>
	 <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz>
	 <20090305210840.GA2499@x200.localdomain>
	 <1236288427.22399.122.camel@nimitz>
	 <20090305220044.GA2819@x200.localdomain>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 16:08:41 +0100
Message-Id: <1236352121.5732.80.camel@bahia>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 01:00 +0300, Alexey Dobriyan wrote:
> On Thu, Mar 05, 2009 at 01:27:07PM -0800, Dave Hansen wrote:
> > > Imagine, unsupported file is opened between userspace checks
> > > for /proc/*/checkpointable and /proc/*/fdinfo/*/checkpointable
> > > and whatever, you stil have to do all the checks inside checkpoint(2).
> > 
> > Alexey, we have two problems here.  I completely agree that we have to
> > do complete and thorough checks of each file descriptor at
> > sys_checkpoint().  Any checks made at other times should not be trusted.
> > 
> > The other side is what Ingo has been asking for.  How do we *know* when
> > we are checkpointable *before* we call (and without calling)
> 
> This "without calling checkpoint(2)" results in much complications
> as demonstrated.
> 
> task_struct and file are not like other structures because they are exposed
> in /proc. For PROC_FS=n kernels, one can't even check.
> 
> You can do checkpoint(2) without actual dump. You pass, you're most
> certainly checkpointable (with inevitable race condition in mind).
> 

Ahhh thank you very much Alexey ! I wanted to explain this to Dave a few
monthes ago but I failed... probably because of my poor English skills.

https://lists.linux-foundation.org/pipermail/containers/2008-October/013549.html

Why would we add checking all over the place when it MUST be done on the
sys_checkpoint() path ? The checkpoint(2) dry-run is definitely the way
to go.

> With time the amount of stuff C/R won't support will approach zero,
> but the infrastructure for "checkpointable" will stay constant.
> If it's too much right now, it will be way too much in future.
> 
> > sys_checkpoint()?  You are yet to acknowledge that this is a valid use
> > case, but it is exactly what Ingo is asking for, I believe.
> 
> It's a valid requirement.
> 
> > If nice printk()s are sufficient to cover what Ingo wants, I'm quite
> > happy to remove the /proc files.  
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

