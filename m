Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbZJOPd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbZJOPd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbZJOPd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:33:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36897 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762826AbZJOPd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:33:58 -0400
Date: Thu, 15 Oct 2009 16:29:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [patch 6/7] um: Convert mmapper to unlocked_ioctl
Message-ID: <20091015162926.25a99cab@lxorguk.ukuu.org.uk>
In-Reply-To: <200910151500.34820.arnd@arndb.de>
References: <20091015083906.716130653@linutronix.de>
	<20091015083933.997426614@linutronix.de>
	<200910151500.34820.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 15:00:34 +0200
Arnd Bergmann <arndbergmann@googlemail.com> wrote:

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

That is wrong.

SuS requires an unknown ioctl code returns -ENOTTY. If the code is
currently remapping it to EINVAL then it wants fixing.
