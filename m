Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYGaOUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYGaOUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYGaOUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:20:18 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:50827 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYGaOUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:20:16 -0400
Date: Thu, 31 Jul 2008 16:20:07 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080731162007.285938e0@surf>
In-Reply-To: <20080731135319.GA20212@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com>
	<20080731093220.969460336@free-electrons.com>
	<20080731135319.GA20212@cs181140183.pp.htv.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thu, 31 Jul 2008 16:53:19 +0300,
Adrian Bunk <bunk@kernel.org> a écrit :

> As I've already said in the past I'm personally not a huge fan of
> these patches, but if it brings advantages in real-life situations
> it's hard to argue against it.

Yes, I've seen your points about that kind of patches on
linux-embedded, and I understand them. I agree that adding dozens and
dozens of configuration items for small features doesn't look like
something sustainable on the long run. However, the kernel keeps
growing and this isn't sustainable either on the long run for *some*
embedded users. So, what should we do ? (That's a real question)

Some numbers about a bootable x86 allnoconfig kernel with ELF, ext2 and
IDE support :

   text	   data	    bss	    dec	    hex	filename
1110389	 119468	 217088	1446945	 161421	vmlinux.2.6.26
1134606	 118840	 212992	1466438	 166046	vmlinux.2.6.27-rc1
  24217    -628   -4096   19493    4C25 +/-

(The only configuration change between the two kernels is
CONFIG_FW_LOADER n->y, which pulls drivers/base/firmware_class.o, 3k).

> In which use cases can users safely disable this option, and on what 
> devices have you verified that CONFIG_FILE_LOCKING=n kernels actually 
> work in practice?

As long as they don't use NFS (realistic in many production
environments) and that the applications do not rely on advisory locking
(flock() and fnctl() F_GETLK and F_SETLK), file locking can be
disabled. In practice, I only tested a CONFIG_FILE_LOCKING=n kernel
with a basic Busybox under Qemu.

Sincerly,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
