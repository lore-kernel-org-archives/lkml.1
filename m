Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbZAQUqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbZAQUqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbZAQUql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:46:41 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51320
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZAQUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:46:40 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [Patch] uml: fix a link error
Date: Sat, 17 Jan 2009 03:28:14 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       jdike@addtoit.com, linux-kernel@vger.kernel.org
References: <20090115194033.GA10926@hack.private> <20090116124158.4364e269.akpm@linux-foundation.org>
In-Reply-To: <20090116124158.4364e269.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901170328.15178.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 14:41:58 Andrew Morton wrote:
> > diff --git a/arch/um/sys-i386/sys_call_table.S
> > b/arch/um/sys-i386/sys_call_table.S index 00e5f52..04147dc 100644
> > --- a/arch/um/sys-i386/sys_call_table.S
> > +++ b/arch/um/sys-i386/sys_call_table.S
> > @@ -6,6 +6,7 @@
> >
> >  #define sys_vm86old sys_ni_syscall
> >  #define sys_vm86 sys_ni_syscall
> > +#define sys_sigprocmask sigprocmask
> >
> >  #define old_mmap old_mmap_i386
>
> For how long has this problem been present?
>
> Why aren't lots of other people reporting it?

I'm not sure User Mode Linux still has a lot of users regularly testing the 
latest and greatest version.  (QEMU and KVM kinda took the wind out of its 
sails.)

I still find it useful to be able to stick printfs into the code and debug 
stuff even when the console isn't working, but I haven't been able to build a 
version of 2.6.28 that works for me at all:

cat > mini.conf << EOF
CONFIG_BINFMT_ELF=y
CONFIG_HOSTFS=y
CONFIG_LBD=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_STDERR_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_EXT2_FS=y
CONFIG_EXT3_FS=y
CONFIG_STATIC_LINK=y
CONFIG_NO_HZ=y
CONFIG_UNEVICTABLE_LRU=y
EOF
make ARCH=um allnoconfig KCONFIG_ALLCONFIG=mini.conf
make ARCH=um -j 3
./linux rw init=/bin/bash rootfstype=hostfs

The result panics (twice) and exits, instead of giving me a shell prompt.  
Built and run on stock Ubuntu 8.10.  (I posted about it on tuesday, but nobody 
replied...)

Rob
