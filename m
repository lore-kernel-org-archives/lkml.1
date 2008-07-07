Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYGGO3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYGGO3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYGGO3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:29:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:58975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYGGO3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:29:44 -0400
Date: Mon, 7 Jul 2008 07:29:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Jinkai Gao" <mickeygjk@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suggestion: LKM should be able to add system call for itself
Message-ID: <20080707072945.189bbe76@infradead.org>
In-Reply-To: <fb82a8210807070512o3a5f8814kba83df94b7c7e04a@mail.gmail.com>
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
	<20080707000128.1e93d8e4@infradead.org>
	<fb82a8210807070512o3a5f8814kba83df94b7c7e04a@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008 08:12:00 -0400
"Jinkai Gao" <mickeygjk@gmail.com> wrote:

> On Mon, Jul 7, 2008 at 3:01 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Mon, 7 Jul 2008 01:09:30 -0400
> > "Jinkai Gao" <mickeygjk@gmail.com> wrote:
> >
> >> Above is to demonstrate that LKM is extension to kernel, and the
> >> system calls should be able to extend as long as the kernel is
> >> extending. So The LKM should be able to define its own user
> >> interface by adding new system call for itself.
> >
> > Since we promise a stable ABI to userspace, this is a bit of a
> > problem.
> >
> > But... look today, we already have various system calls implemented
> > by modules. (example: sys_nfsservctl)
> > but to make it fully dynamic? Not a good idea... nobody would be
> > able to program to it.
> 
> Why? Using the interface we provide to add and delete system call (the
> module can only unregister the system calls registered by itself), all
> the existing system calls will be the same. It is just you can have
> more system calls then you need, That shouldn't be a problem.

but when the kernel later adds new ones.. overlap.

Really.. it's not hard to do this. Look at nfs etc. You CAN do this,
just you need to reserve your system call number officially (and create
a manpage for it describing what it does)... and then it doesn't really
matter if it's module or vmlinux who provides it. Again.. nfs has
solved this.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
