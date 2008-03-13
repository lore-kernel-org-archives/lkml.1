Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYCMVs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYCMVs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYCMVsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:48:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47116 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYCMVsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:48:19 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
In-Reply-To: <20080312170458.2fd5a490.akpm@linux-foundation.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D86D43.2060108@imap.cc>
	 <20080312170458.2fd5a490.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 14:48:10 -0700
Message-Id: <1205444890.25188.9.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-12 at 17:04 -0700, Andrew Morton wrote: 
> On Thu, 13 Mar 2008 00:54:43 +0100
> Tilman Schmidt <tilman@imap.cc> wrote:
> 
> > Am 11.03.2008 09:14 schrieb Andrew Morton:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> > 
> > This still complains during startup:
> > 
> > <6>[    0.063442] Checking 'hlt' instruction... OK.
> > <0>[    0.068233] BUG: spinlock bad magic on CPU#0, swapper/0
> > <0>[    0.068996]  lock: c2c19380, .magic: 00000000, .owner: swapper/0, .owner_cpu: 0
> > <4>[    0.069227] Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1-testing #1
> > <4>[    0.069369]  [spin_bug+124/135] spin_bug+0x7c/0x87
> > <4>[    0.069563]  [_raw_spin_unlock+25/113] _raw_spin_unlock+0x19/0x71
> > <4>[    0.069752]  [_spin_unlock+29/60] _spin_unlock+0x1d/0x3c
> > <4>[    0.069941]  [mnt_want_write+98/136] mnt_want_write+0x62/0x88
> > <4>[    0.070131]  [sys_mkdirat+134/214] sys_mkdirat+0x86/0xd6
> > <4>[    0.070322]  [clean_path+22/74] ? clean_path+0x16/0x4a
> > <4>[    0.070558]  [kfree+216/236] ? kfree+0xd8/0xec
> > <4>[    0.070793]  [sys_mkdir+16/18] sys_mkdir+0x10/0x12
> > <4>[    0.070995]  [do_name+274/435] do_name+0x112/0x1b3
> > <4>[    0.071184]  [write_buffer+29/44] write_buffer+0x1d/0x2c
> > <4>[    0.071371]  [flush_window+100/179] flush_window+0x64/0xb3
> > <4>[    0.071558]  [unpack_to_rootfs+1580/2233] unpack_to_rootfs+0x62c/0x8b9
> > <4>[    0.071747]  [populate_rootfs+32/265] populate_rootfs+0x20/0x109
> > <4>[    0.071995]  [alternative_instructions+339/344] ? alternative_instructions+0x153/0x158
> > <4>[    0.072235]  [start_kernel+835/853] start_kernel+0x343/0x355
> > <4>[    0.072422]  [i386_start_kernel+8/10] i386_start_kernel+0x8/0xa
> > <4>[    0.072610]  =======================
> > <6>[    0.072808] Unpacking initramfs... done
> > 
> > System comes up fine, though. Not sure whom to CC.
> 
> Dave, methinks.
> 
> > Machine's a dual-core Pentium D running a 32 bit kernel.
> > Let me know if you want me to provide more information or test anything.

I'm really confused by this one.  It looks to me like the initcalls got
all out of whack in their ordering.  There's no way in hell that the
populate_rootfs() call should be happening right next to cpu
initialization:

> > <6>[    0.063442] Checking 'hlt' instruction... OK.

If you can send me your vmlinux (not vmlinuz), I'll see how the
initcalls are laid out in it.  What distro and compiler are you on?

-- Dave

