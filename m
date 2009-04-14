Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbZDNSfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbZDNSfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759262AbZDNSdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:33:22 -0400
Received: from emailgw02.pnl.gov ([192.101.109.34]:53890 "EHLO
	emailgw02.pnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267AbZDNSdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:33:20 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 14:33:20 EDT
X-IronPort-AV: E=Sophos;i="4.40,186,1239001200"; 
   d="scan'208";a="66811477"
Subject: Re: "partial" container checkpoint
From: Kevin Fox <Kevin.Fox@pnl.gov>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org, mingo@elte.hu,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <1239727023.32604.69.camel@nimitz>
References: <20090410023539.GK27788@x200.localdomain>
	 <20090413214701.GA24509@us.ibm.com> <49E424A3.60606@cs.columbia.edu>
	 <20090414152951.GA7703@us.ibm.com>  <1239727023.32604.69.camel@nimitz>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 10:30:59 -0700
Message-Id: <1239730259.8471.607.camel@sledge.emsl.pnl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 09:37 -0700, Dave Hansen wrote:
> On Tue, 2009-04-14 at 10:29 -0500, Serge E. Hallyn wrote:
> > I think the perceived need for it comes, as above, from the pure
> > checkpoint-a-whole-container-only view.  So long as you will
> > checkpoint/restore a whole container, then you'll end up doing
> > something requiring privilege anyway.  But that is not all of
> > the use cases.
> 
> Yeah, there are certainly a lot of shades of gray here.  I've been
> talking to some HPC guys in the last couple of days.  They certainly
> have a need for checkpoint/restart, but much less of a need for doing
> entire containers.  

We'd be uncomfortable running partial checkpoints. We'd much rather have
slurm spawn off a container and just checkpoint that. Who knows what
users code spawns off other processes...

Kevin

> 
> It also occurs to me that we have the potential to pull some
> long-out-of-tree users back in.  VMADump users, for instance:
> 
> 	http://bproc.sourceforge.net/c268.html
> 
> If we could do *just* a selective checkpoint of a single process's VMAs,
> the bproc users could probably use sys_checkpoint() in some way.  That's
> *way* less than an entire container, but it would be really useful to
> some people.   
> 
> -- Dave
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

