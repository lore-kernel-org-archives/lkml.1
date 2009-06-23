Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZFWMYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZFWMYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZFWMYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:24:32 -0400
Received: from nox.protox.org ([88.191.38.29]:32816 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbZFWMYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:24:32 -0400
Subject: Re: [PATCH] radeon: use vmalloc instead of kmalloc
From: Jerome Glisse <glisse@freedesktop.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jerome Glisse <jglisse@redhat.com>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970906230442n3dcfeff8le0ffc3b8ea0c3bd0@mail.gmail.com>
References: <1245691561-15336-1-git-send-email-jglisse@redhat.com>
	 <1245756936.19816.1652.camel@twins>
	 <21d7e9970906230442n3dcfeff8le0ffc3b8ea0c3bd0@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 14:23:23 +0200
Message-Id: <1245759803.2674.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 21:42 +1000, Dave Airlie wrote:
> On Tue, Jun 23, 2009 at 9:35 PM, Peter Zijlstra<peterz@infradead.org> wrote:
> > On Mon, 2009-06-22 at 19:26 +0200, Jerome Glisse wrote:
> >> We don't need to allocated contiguous pages in cs codepath
> >> so use vmalloc instead.
> >
> > Best would be to not require >PAGE_SIZE allocations at all of course.
> 
> It gets messy when you have copy from user and spinlocks, it would be nice
> to just parse the userspace PAGE_SIZE at a time, but it would mean dropping
> a lock we probably need to hold.
> 
> > But barring that, it would be great to have something like:
> >
> >  ptr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> >  if (!ptr)
> >    ptr = vmalloc(size);
> 
> we have a drm_calloc_large workaround already for the Intel driver which also
> need this.
> >
> > Also, how long do these allocations live? vmalloc space can be quite
> > limited (i386) and it can fragment too.
> 
> Only an ioctl lifetime so they aren't that bad. We however do have some vmaps
> that might be quite large, mainly the fbcon framebuffer (up to 8MB in
> some cases)
> 
> Dave.


I will rework cs parsing a bit see with what i can come up with. Forget
this patch, i will get back with a new one.

Jerome

