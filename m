Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbZE1Q4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbZE1Q4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZE1Q4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:56:33 -0400
Received: from relay3.sgi.com ([192.48.156.57]:53365 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751322AbZE1Q4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:56:33 -0400
Date: Thu, 28 May 2009 11:56:25 -0500
From: Russ Anderson <rja@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>, hugh@veritas.com, riel@redhat.com,
       akpm@linux-foundation.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, rja@sgi.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090528165625.GA17572@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <200905271012.668777061@firstfloor.org> <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528093141.GD1065@one.firstfloor.org> <20090528120854.GJ6920@wotan.suse.de> <20090528134520.GH1065@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528134520.GH1065@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 03:45:20PM +0200, Andi Kleen wrote:
> On Thu, May 28, 2009 at 02:08:54PM +0200, Nick Piggin wrote:
> > > > > +			printk(KERN_ERR "MCE: Out of memory while machine check handling\n");
> > > > > +			return;
> > > > > +		}
> > > > > +	}
> > > > > +	tk->addr = page_address_in_vma(p, vma);
> > > > > +	if (tk->addr == -EFAULT) {
> > > > > +		printk(KERN_INFO "MCE: Failed to get address in VMA\n");
> > > > 
> > > > I don't know if this is very helpful message. I could legitimately happen and
> > > > nothing anybody can do about it...
> > > 
> > > Can you suggest a better message?
> > 
> > Well, for userspace, nothing? At the very least ratelimited, and preferably
> > telling a more high level of what the problem and consequences are.
> 
> I changed it to 
> 
>  "MCE: Unable to determine user space address during error handling\n")
> 
> Still not perfect, but hopefully better.

Is it even worth having a message at all?  Does the fact that page_address_in_vma()
failed change the behavior in any way?  (Does tk->addr == 0 matter?)  From
a quick scan of the code I do not believe it does.

If the message is for developers/debugging, it would be nice to have more
information, such as why did page_address_in_vma() return -EFAULT.  If
that is important, page_address_in_vma() sould return a different failure 
status for each of the three failing conditions.  But that would only
be needed if the code (potentially) was going to do some additional handling.


Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
