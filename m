Return-Path: <linux-kernel-owner+w=401wt.eu-S934463AbXFFBU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463AbXFFBU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933190AbXFFBUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:20:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933451AbXFFBUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:20:48 -0400
Date: Tue, 5 Jun 2007 18:20:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] UML - Fix kernel stack size on x86_64
Message-Id: <20070605182024.003502d4.akpm@linux-foundation.org>
In-Reply-To: <20070606003752.GA11511@c2.user-mode-linux.org>
References: <20070605205055.GA9770@c2.user-mode-linux.org>
	<20070605170001.c8b2110e.akpm@linux-foundation.org>
	<20070606003752.GA11511@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 20:37:52 -0400 Jeff Dike <jdike@addtoit.com> wrote:

> On Tue, Jun 05, 2007 at 05:00:01PM -0700, Andrew Morton wrote:
> > On Tue, 5 Jun 2007 16:50:55 -0400
> > Jeff Dike <jdike@addtoit.com> wrote:
> > 
> > > [ This is 2.6.22 material ]
> > > 
> > > Having KERNEL_STACK_ORDER in defconfig overrides the value provided by
> > > Kconfig, breaking UML/x86_64, which wants 2 page stacks.
> 
> > That means the Kconfig rules are wrong, surely?
> 
> I'm far from a Kconfig expert,

Me either.  I learn enough for the problem at hand, then instaforget it
again.  Kinda like perl.

> but what I have is
> 
> config KERNEL_STACK_ORDER
> 	int "Kernel stack size order"
> 	default 1 if 64BIT
> 	default 0 if !64BIT
> 
> which seems reasonably clear and simple...
> 

hm, OK, there's the problem.  This is an offered-to-the-user config option.

If you do

-	int "Kernel stack size order"
+	int

then this rule will no longer be offered to the user and `make oldconfig'
(actually anythingconfig) will override whatever happens to be in .config
for KERNEL_STACK_ORDER.

I'm not sure if that's actually what you want, but if the current situation
is that a random CONFIG_KERNEL_STACK_ORDER=0 left over in .config will
break the kernel at runtime then I think something sterner than editing
defconfig is needed?

