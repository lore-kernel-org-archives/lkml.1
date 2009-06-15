Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbZFOMzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbZFOMzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZFOMyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:54:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51975 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbZFOMyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:54:50 -0400
Date: Mon, 15 Jun 2009 15:54:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
	of an explicit ioctl
Message-ID: <20090615125439.GI6351@redhat.com>
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <20090604124812.10544.5811.stgit@dev.haskins.net> <20090614114854.GA10269@redhat.com> <4A34F2B7.1030606@novell.com> <20090614132843.GC10646@redhat.com> <4A35C269.7050209@novell.com> <20090615094650.GA4949@redhat.com> <4A3639B2.7080006@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3639B2.7080006@novell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 08:08:18AM -0400, Gregory Haskins wrote:
> >> @@ -123,6 +124,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int
> >> sync, void
> >>  *key)
> >>  
> >>                 cleanup_srcu_struct(&irqfd->srcu);
> >>                 kfree(irqfd);
> >> +               module_put(THIS_MODULE);
> >>         }
> >>  
> >>         return 0;
> >>     
> >
> > module_put(THIS_MODULE) is always a bug unless you know that someone has
> > a reference to the current module: the module could go away between this
> > call and returning from function.
> >   
> 
> Hmm.  I understand what you are saying conceptually (i.e. the .text
> could get yanked before we hit the next line of code, in this case the
> "return 0").  However, holding a reference when you _know_ someone else
> holds a reference to me says that one of the references is redundant. 
> In addition, there is certainly plenty of precedence for
> module_put(THIS_MODULE) all throughout the kernel (including
> module_put_and_exit()).  Are those broken as well?

Maybe not, but I don't know why. It works fine as long as you don't
unload any modules though :) Rusty, could you enlighten us please?


-- 
MST
