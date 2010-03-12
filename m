Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab0CLQkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 11:40:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:47569 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab0CLQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 11:40:51 -0500
Date: Fri, 12 Mar 2010 08:35:59 -0800
From: Greg KH <gregkh@suse.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "pasik@iki.fi" <pasik@iki.fi>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: patch
 x86-xen-disable-highmem-pte-allocation-even-when-config_highpte-y.patch
 added to 2.6.33-stable tree
Message-ID: <20100312163559.GA7562@suse.de>
References: <12683359492650@site>
 <201003121508.54384.s.L-H@gmx.de>
 <1268403453.10129.7360.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1268403453.10129.7360.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 02:17:33PM +0000, Ian Campbell wrote:
> On Fri, 2010-03-12 at 14:08 +0000, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Friday 12 March 2010, gregkh@suse.de wrote:
> > > This is a note to let you know that we have just queued up the patch titled
> > > 
> > >     Subject: x86, xen: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y
> > > 
> > > to the 2.6.33-stable tree.  Its filename is
> > > 
> > >     x86-xen-disable-highmem-pte-allocation-even-when-config_highpte-y.patch
> > > 
> > > A git repo of this tree can be found at 
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > 
> > > From 817a824b75b1475f1b067c8cee318c7b4d66fcde Mon Sep 17 00:00:00 2001
> > > From: Ian Campbell <ian.campbell@citrix.com>
> > > Date: Fri, 26 Feb 2010 17:16:00 +0000
> > > Subject: x86, xen: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y
> > > MIME-Version: 1.0
> > > Content-Type: text/plain; charset=UTF-8
> > > Content-Transfer-Encoding: 8bit
> > > 
> > > From: Ian Campbell <ian.campbell@citrix.com>
> > > 
> > > commit 817a824b75b1475f1b067c8cee318c7b4d66fcde upstream.
> > > 
> > > There's a path in the pagefault code where the kernel deliberately
> > > breaks its own locking rules by kmapping a high pte page without
> > > holding the pagetable lock (in at least page_check_address). This
> > > breaks Xen's ability to track the pinned/unpinned state of the
> > > page. There does not appear to be a viable workaround for this
> > > behaviour so simply disable HIGHPTE for all Xen guests.
> > 
> > This patch breaks compilation of the current 2.6.33 -stable queue and might
> > also affect queue-2.6.32 (untested):
> > 
> >   CC      arch/x86/xen/enlighten.o
> > arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
> > arch/x86/xen/enlighten.c:1102: error: ‘__userpte_alloc_gfp’ undeclared (first use in this function)
> > arch/x86/xen/enlighten.c:1102: error: (Each undeclared identifier is reported only once
> > arch/x86/xen/enlighten.c:1102: error: for each function it appears in.)
> > make[2]: *** [arch/x86/xen/enlighten.o] Error 1
> > make[1]: *** [arch/x86/xen] Error 2
> > 
> > as it seems to depend (tested) on:
> > 
> > commit 14315592009c17035cac81f4954d5a1f4d71e489
> > Author: Ian Campbell <ian.campbell@citrix.com>
> > Date:   Wed Feb 17 10:38:10 2010 +0000
> > 
> >     x86, mm: Allow highmem user page tables to be disabled at boot time
> 
> Thanks Stefan, this is indeed the correct fix. I pointed Greg to this
> patch in private mail this morning.

I've just added it.  Odd that the kernel doesn't fail on my builds.  Oh,
I'm not enabling Xen, that's why, my fault...

thanks,

greg k-h
