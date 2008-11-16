Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbYKPQLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbYKPQLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYKPQLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:11:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:49867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbYKPQLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:11:42 -0500
Date: Sun, 16 Nov 2008 17:11:39 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116171139.0456b1b2@kopernikus.site>
In-Reply-To: <20081116154541.1f196f1e@lxorguk.ukuu.org.uk>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<20081116150756.3cece2de@lxorguk.ukuu.org.uk>
	<20081116162003.04267538@kopernikus.site>
	<20081116154541.1f196f1e@lxorguk.ukuu.org.uk>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox [2008-11-16 15:45]:
>
> > I don't need to explain what protection STRICT_DEVMEM provides, just
> > because I didn't submit STRICT_DEVMEM. However:
> 
> Which also doesn't explain what this turd is for.

Could we discuss more factual without words like "turd", please?

> >     Author: Arjan van de Ven <arjan@linux.intel.com>
> >     Date:   Thu Apr 24 23:40:47 2008 +0200
> > 
> >     The X server needs access to /dev/mem for the PCI space, but it doesn't need
> >     access to memory; both the file permissions and SELinux permissions of /dev/mem
> >     just make X effectively super-super powerful. With the exception of the
> >     BIOS area, there's just no valid app that uses /dev/mem on actual memory.
> 
> Note that this statement directly conflicts with your debugging statement
> you need it switchable, and directly conflicts with the Red Hat crash
> memory access. So you are trying to support something with a changelog
> that demonstrates that what you are trying to make configurable is
> completely broken anyway
> 
> The functionality provided by STRICT_DEVMEM is the same with it on or off
> - absolutely *nothing*.

Even with SELinux?

> You can turn it off at boot time, but if you intend not to use it then it
> is better (and measurably so with microbenchmark tools) to compile
> without it. Red Hat doesn't do the two kernels as the maintenance cost
> exceeds the gain for customers.

And that's the same argument why SUSE does not ship a -devmem and a
-nodevmem kernel. When you turn it off, you lose the protection that is
there if you use SELinux / Apparmor. If you turn it on, you cannot use
crash.

 Note however that compiling it out really
> does compile it *out* and the overhead is gone totally for the many
> embedded and other devices that don't use it.

For SELinux, yes. 

> > But I never used it. At least I don't see -selinux and -noselinux
> > kernels in Redhat.
> 
> It is Red Hat, two words and a trademark (sorry but our legal people
> insist we remind people who get it wrong).

Oh well, I don't tell it our legal people if you would write SuSE
instead of SUSE. Even not S.u.S.E. ;-)

> > However, with my patch you can make everything configurable. With
> > SELinux or Apparmor you can also protect the user from writing that
> > sysctl. Or from loading kernel modules that circumvent that protection.
> 
> With your patch I get crap in the kernel I don't need. In every kernel
> including those on memory tight devices like wireless routers that don't
> need it.

Well, if you let the CONFIG option there and only add the sysfs entry
it does not. Even most embedded stuff is not x86.

> Even if you want to turd polish there are cleaner solutions. A process
> with CAP_SYS_RAWIO can cheerfully bypass any restriction you try and
> place so you could rip out all the sysctl crap and just say that
> the /dev/mem restriction doesn't apply to a CAP_SYS_RAWIO process.

According to Arjan that does not work.


Regards,
Bernhard
