Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXGOHvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXGOHvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 03:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXGOHv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 03:51:28 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:55587 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbXGOHv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 03:51:27 -0400
Date: Sun, 15 Jul 2007 09:51:44 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
Message-ID: <20070715075144.GA12216@aepfle.de>
References: <20070714205709.GA9478@aepfle.de> <8bd0f97a0707141404k16e53945s92b3cd4264ecf0aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8bd0f97a0707141404k16e53945s92b3cd4264ecf0aa@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, Mike Frysinger wrote:

> On 7/14/07, Olaf Hering <olaf@aepfle.de> wrote:
> >Declare PAGE_SIZE as getpagesize() for userspace.
> >PAGE_SIZE is used in resource.h and shm.h
> >
> >define PAGE_SIZE in asm-generic/page.h
> >guard get_order() with _ARCH_HAS_GET_ORDER for ia64 and xtensa
> >include asm-generic/page.h in asm/page.h
> >make asm/page.h nearly empty by moving the #ifdef guards up
> >remove unneeded page.h export from frv
> 
> imo, asm/page.h should just go away for userspace.  the attached patch
> is what i've been using in Gentoo ... but somethings (like an arch or
> two in glibc) still assume asm/page.h is OK.  in general though,
> considering asm/page.h has become so unreliable lately (a large number
> of arches ifdef the whole thing out), most packages out there have
> updated already to use the userspace interface from unistd.h.
> -mike

nothing appears to use linux/shm.h and linux/resource.h

strace-4.5.15 uses linux/a.out.h in #ifdef LINUXSPARC

glibc uses asm/elf.h in sys/procfs.h, also in alpha and powerpc.

kexec-tools use linux/elf.h

psmisc and ltrace use linux/user.h
glibc (for sh) and mono-debugger use asm/user.h

And alot of asm/page.h users.

Thats the upstream status today. What you do at home doesnt really
matter.
