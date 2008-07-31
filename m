Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYGaPjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYGaPjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYGaPiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:38:55 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47786 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbYGaPiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:38:54 -0400
Date: Thu, 31 Jul 2008 18:37:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080731153757.GB20212@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080731135319.GA20212@cs181140183.pp.htv.fi> <20080731162007.285938e0@surf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080731162007.285938e0@surf>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 04:20:07PM +0200, Thomas Petazzoni wrote:
> Le Thu, 31 Jul 2008 16:53:19 +0300,
> Adrian Bunk <bunk@kernel.org> a écrit :
> 
> > As I've already said in the past I'm personally not a huge fan of
> > these patches, but if it brings advantages in real-life situations
> > it's hard to argue against it.
> 
> Yes, I've seen your points about that kind of patches on
> linux-embedded, and I understand them. I agree that adding dozens and
> dozens of configuration items for small features doesn't look like
> something sustainable on the long run. However, the kernel keeps
> growing and this isn't sustainable either on the long run for *some*
> embedded users. So, what should we do ? (That's a real question)

I'm not against making the kernel smaller.

I'm just not a fan of adding config options for each few kB of code - 
we have to maintain them and the more complex the configuration becomes 
the more often it breaks.

> Some numbers about a bootable x86 allnoconfig kernel with ELF, ext2 and
> IDE support :
> 
>    text	   data	    bss	    dec	    hex	filename
> 1110389	 119468	 217088	1446945	 161421	vmlinux.2.6.26
> 1134606	 118840	 212992	1466438	 166046	vmlinux.2.6.27-rc1
>   24217    -628   -4096   19493    4C25 +/-

What became bigger was most likely not related to the patches you sent.

Where and why did the kernel become bigger?

> (The only configuration change between the two kernels is
> CONFIG_FW_LOADER n->y, which pulls drivers/base/firmware_class.o, 3k).

Why did CONFIG_FW_LOADER get enabled?
Due to alnoconfig disabling CONFIG_EMBEDDED?

> > In which use cases can users safely disable this option, and on what 
> > devices have you verified that CONFIG_FILE_LOCKING=n kernels actually 
> > work in practice?
> 
> As long as they don't use NFS (realistic in many production
> environments) and that the applications do not rely on advisory locking
> (flock() and fnctl() F_GETLK and F_SETLK), file locking can be
> disabled.

But what does that mean in practice?

A user will ask:
I'm using $applications with $libraries, can I safely disable this option?

And e.g. according to a quick grep through the sources uClibc's 
updwtmp() seems to cease working without flock().

It costs us maintainance of the option and the #ifdef's and gives users 
one way more to shoot themselves into the foot in nontrivial to detect 
ways.

> In practice, I only tested a CONFIG_FILE_LOCKING=n kernel
> with a basic Busybox under Qemu.
> 
> Sincerly,
> 
> Thomas

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

