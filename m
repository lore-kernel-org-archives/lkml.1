Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbZJOO6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbZJOO6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762210AbZJOO6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:58:10 -0400
Received: from www.tglx.de ([62.245.132.106]:46986 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760651AbZJOO6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:58:09 -0400
Date: Thu, 15 Oct 2009 16:50:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [patch 6/7] um: Convert mmapper to unlocked_ioctl
In-Reply-To: <200910151500.34820.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910151639370.9428@localhost.localdomain>
References: <20091015083906.716130653@linutronix.de> <20091015083933.997426614@linutronix.de> <200910151500.34820.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Arnd Bergmann wrote:

> On Thursday 15 October 2009, Thomas Gleixner wrote:
> > The ioctl is empty and needs no serialization. We might remove it
> > completely but that would change the return value from -ENOIOCTLCMD to
> > -ENOTTY.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Jeff Dike <jdike@addtoit.com>
> 
> This one is tricky if you want to get it right according to the
> book. ENOIOCTLCMD is never a valid return code for user space,
> but sys_ioctl passes it down anyway.
> 
> However, returning -ENOIOCTLCMD from an *unlocked_ioctl* function
> automatically gets turned into -EINVAL. It does this to allow
> the same functions to be used for unlocked_ioctl and compat_ioctl.
> In effect, this patch is functionally identical to removing the
> ioctl function, which I think is what should be done here.

Yeah, we get either -ENOTTY or -EINVAL which always changes the user
space return value. So yes, removing it at least saves some line of
code :)

Thanks,

	tglx
