Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZCFI4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZCFI4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZCFI40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:56:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:12526 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZCFI40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:56:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xq+8BN96FW/YJ4DTaO4O73kdPzy6zglFkT5FxnQaVFgeVqFh4GRTfD0Qg1ZNHdKS6Y
         ZJcEILRC508YU9ZAnyKXKjXbWhATRtJorz4FZzQVJBIT4F9wnMBs1fDI3OeKJ36RhMuC
         gJcEAYRwaQcIgHnlzXcd9TDq/P2SZmAx7hCOU=
Date: Fri, 6 Mar 2009 12:03:13 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
Message-ID: <20090306090313.GB4225@x200.localdomain>
References: <49B0CAEC.80801@cn.fujitsu.com> <20090306082056.GB3450@x200.localdomain> <49B0DE89.9000401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B0DE89.9000401@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 04:27:53PM +0800, Li Zefan wrote:
> Alexey Dobriyan wrote:
> > On Fri, Mar 06, 2009 at 03:04:12PM +0800, Li Zefan wrote:
> >> I notice there are many places doing copy_from_user() which follows
> >> kmalloc():
> >>
> >>         dst = kmalloc(len, GFP_KERNEL);
> >>         if (!dst)
> >>                 return -ENOMEM;
> >>         if (copy_from_user(dst, src, len)) {
> >> 		kfree(dst);
> >> 		return -EFAULT
> >> 	}
> >>
> >> kmemdup_from_user() is a wrapper of the above code. With this new
> >> function, we don't have to write 'len' twice, which can lead to
> >> typos/mistakes. It also produces smaller code.
> > 
> > Name totally sucks, it mixes kernel idiom of allocation with purely
> > userspace function.
> > 
> 
> I'm not good at English, and I don't know why "kernel memory duplicated
> from user space" is so bad...
> 
> or memdup_user() ?
> 
> >> A qucik grep shows 250+ places where kmemdup_from_user() *may* be
> >> used. I'll prepare a patchset to do this conversion.
> > 
> > 250?
> > 
> 
> I just found out how many copy_from_user() following km/zalloc(), so
> not all of them are replace-able.
> 
> > Let's not add wrapper for every two lines that happen to be used
> > together.
> > 
> 
> Why not if we have good reasons? And I don't think we can call this
> "happen to" if there are 250+ of them?

Please, read through them. This "250+" number suddenly will become
like 20, because wrapper is not good enough.
