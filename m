Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbZJQC6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbZJQC6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 22:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZJQC6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 22:58:49 -0400
Received: from www.tglx.de ([62.245.132.106]:33797 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZJQC6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 22:58:49 -0400
Date: Sat, 17 Oct 2009 04:58:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arndbergmann@googlemail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [patch 6/7] um: Convert mmapper to unlocked_ioctl
In-Reply-To: <200910162142.50618.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0910170456530.2890@localhost.localdomain>
References: <20091015083906.716130653@linutronix.de> <200910151500.34820.arnd@arndb.de> <20091015162926.25a99cab@lxorguk.ukuu.org.uk> <200910162142.50618.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, Arnd Bergmann wrote:

> On Thursday 15 October 2009, Alan Cox wrote:
> > On Thu, 15 Oct 2009 15:00:34 +0200
> > Arnd Bergmann <arndbergmann@googlemail.com> wrote:
> >
> > > However, returning -ENOIOCTLCMD from an *unlocked_ioctl* function
> > > automatically gets turned into -EINVAL. It does this to allow
> > > the same functions to be used for unlocked_ioctl and compat_ioctl.
> > > In effect, this patch is functionally identical to removing the
> > > ioctl function, which I think is what should be done here.
> > 
> > That is wrong.
> > 
> > SuS requires an unknown ioctl code returns -ENOTTY. If the code is
> > currently remapping it to EINVAL then it wants fixing.
> 
> Right, I forgot about the EINVAL/ENOTTY difference. The code currently
> returns -ENOIOCTLCMD, which is worse. Thomas' patch makes it return
> -EINVAL, which as you said is still wrong. Removing the ioctl function
> will do the right thing and return -ENOTTY, so that should be done
> here in um/mmapper, with an appropriate changelog.
> 
> For the common code in fs/ioctl.c, I think the current behaviour is
> correct. It returns -EINVAL if the driver returns -ENOIOCTLCMD, iow

Only the unlocked_ioctl code path, the locked one returns whatever
crap comes from the ioctl implementation.

> "the request [...] argument is not valid for this device", as specified
> by http://www.opengroup.org/onlinepubs/009695399/functions/ioctl.html.
 
> Drivers returning ENOIOCTLCMD for every request are broken and should
> be changed to have no ioctl function.

Ack.

	tglx
