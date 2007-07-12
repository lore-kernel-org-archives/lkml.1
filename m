Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXGLXUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXGLXUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbXGLXUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:20:13 -0400
Received: from ozlabs.org ([203.10.76.45]:45315 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbXGLXUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:20:12 -0400
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hch@lst.de,
       linux-kernel@vger.kernel.org, carsteno <carsteno@de.ibm.com>
In-Reply-To: <46960C27.5040803@qumranet.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070711122324.GA21714@lst.de>
	 <1184203311.6005.664.camel@localhost.localdomain>
	 <20070711.192829.08323972.davem@davemloft.net>
	 <1184208521.6005.695.camel@localhost.localdomain>
	 <20070711212435.abd33524.akpm@linux-foundation.org>
	 <1184215943.6005.745.camel@localhost.localdomain>
	 <46960C27.5040803@qumranet.com>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 09:20:05 +1000
Message-Id: <1184282405.6005.803.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 14:10 +0300, Avi Kivity wrote:
> Rusty Russell wrote:
> > Remove export of __put_task_struct, and usage in lguest
> >
> > lguest takes a reference count of tasks for two reasons.  The first is
> > bogus: the /dev/lguest close callback will be called before the task
> > is destroyed anyway, so no need to take a reference on open.
> >
> >   
> 
> What about
> 
>   Open /dev/lguest
>   transfer fd using SCM_RIGHTS (or clone()?)
>   close fd in original task
>   exit()
> 
> ?
> 
> My feeling is that if you want to be bound to a task, not a file, you 
> need to use syscalls, not ioctls.

"Don't do that".  You'll lose the ability to access the operations on
the fd once you are no longer the original task (explicit check).,

It's not an exact match, but a file is a remarkably convenient
abstraction for a non-ABI such as lguest.  Of course, Carsten was
talking about unifying the lguest & kvm userspace interface, so this
could well change anyway.

Cheers,
Rusty.

