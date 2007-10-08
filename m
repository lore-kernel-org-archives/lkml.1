Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbXJHRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbXJHRwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbXJHRwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:52:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbXJHRwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:52:09 -0400
Date: Mon, 8 Oct 2007 10:51:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: yanzheng@21cn.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       ltp-list@lists.sourceforge.net
Subject: Re: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
Message-Id: <20071008105120.4e0e4a85.akpm@linux-foundation.org>
In-Reply-To: <20071008102843.d20b56d7.randy.dunlap@oracle.com>
References: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
	<20071008100456.dbe826d0.akpm@linux-foundation.org>
	<20071008102843.d20b56d7.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 10:28:43 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 8 Oct 2007 10:04:56 -0700 Andrew Morton wrote:
> 
> > On Mon, 8 Oct 2007 19:45:08 +0800 "Yan Zheng" <yanzheng@21cn.com> wrote:
> > 
> > > Hi all
> > > 
> > > The test for VM_CAN_NONLINEAR always fails
> > > 
> > > Signed-off-by: Yan Zheng<yanzheng@21cn.com>
> > > ----
> > > diff -ur linux-2.6.23-rc9/mm/fremap.c linux/mm/fremap.c
> > > --- linux-2.6.23-rc9/mm/fremap.c	2007-10-07 15:03:33.000000000 +0800
> > > +++ linux/mm/fremap.c	2007-10-08 19:33:44.000000000 +0800
> > > @@ -160,7 +160,7 @@
> > >  	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
> > >  		goto out;
> > > 
> > > -	if (!vma->vm_flags & VM_CAN_NONLINEAR)
> > > +	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
> > >  		goto out;
> > > 
> > >  	if (end <= start || start < vma->vm_start || end > vma->vm_end)
> > 
> > Lovely.  From this we can deduce that nobody has run remap_file_pages() since
> > 2.6.23-rc1 and that nobody (including the developer who made that change) ran it
> > while that change was in -mm.
> 
> I've run rmap-test with -M (use remap_file_pages) and
> remap-test from ext3-tools, but not remap_file_pages for some reason.
> 
> I'll now add remap_file_pages soon.
> Maybe those other 2 tests aren't strong enough (?).
> Or maybe they don't return a non-0 exit status even when they fail...
> (I'll check.)

Perhaps Yan Zheng can tell us what test was used to demonstrate this?

> 
> > I'm surprise that LTP doesn't have any remap_file_pages() tests.
> 
> quick grep didn't find any for me.

Me either.  There are a few lying around the place which could be
integrated.

It would be good if LTP were to have some remap_file_pages() tests
(please).  As we see here, it is something which we can easily break, and
leave broken for some time.

