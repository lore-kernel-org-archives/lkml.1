Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZAaA1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZAaA1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZAaA1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:27:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZAaA1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:27:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kbuild: drop check for CONFIG_ in headers_check
Date: Sat, 31 Jan 2009 01:27:02 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1233342254.21493.8.camel@localhost.localdomain> <20090130225642.GA17950@uranus.ravnborg.org> <20090130234012.GF4922@elte.hu>
In-Reply-To: <20090130234012.GF4922@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901310127.03142.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19eQQfUHT8cH/k6vd37YUfc0kSZBUga1YkxNcL
 1N3nj5CXvZvjLktrXJuNCEEHukGKLF9tu3HkJukdKvobN+50eN
 Zq+uulTkWVAEr7JAPmGfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 January 2009, Ingo Molnar wrote:
> Jaswinder, i think we now have a realistic chance to reach a zero baseline 
> with these warnings, for v2.6.29. Here are the remaining warnings (summed 
> up per file) on x86 (after Sam's patch):
> 
>      17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
>      12 /dev/shm/tip/usr/include/linux/soundcard.h
>       3 /dev/shm/tip/usr/include/linux/nubus.h
>       2 /dev/shm/tip/usr/include/linux/in6.h
>       1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
>       1 /dev/shm/tip/usr/include/linux/socket.h
>       1 /dev/shm/tip/usr/include/linux/coda_psdev.h
>       1 /dev/shm/tip/usr/include/linux/bsg.h
> 

Ah, that doesn't look too bad. On a related subject, was there ever a
conclusion about whether we want to support __KERNEL_STRICT_NAMES in
every header? When that is set, headers cannot use most of the standard
types (dev_t, mode_t, off_t, pid_t, suseconds_t, timer_t, uid_t, gid_t,
loff_t, time_t, clock_t, caddr_t, pgoff_t, {u_,u,}int{8,16,32,64}_6})
but have to use the __kernel_* versions of that.

It doesn't seem hard to fix, but I'm not sure if it needs to be touched.
If we decide to fix it, it's easy enough to do during headers_install,
or once for the whole tree. The __kernel_* types need this patch:

 asm-generic/fcntl.h               |   12 ++++++------
 asm-generic/siginfo.h             |   14 +++++++-------
 linux/agpgart.h                   |   14 +++++++-------
 linux/cn_proc.h                   |   20 ++++++++++----------
 linux/cyclades.h                  |    6 +++---
 linux/dvb/video.h                 |    2 +-
 linux/if_pppol2tp.h               |    2 +-
 linux/mroute6.h                   |    2 +-
 linux/netfilter_ipv4/ipt_owner.h  |    8 ++++----
 linux/netfilter_ipv6/ip6t_owner.h |    8 ++++----
 linux/ppp_defs.h                  |    4 ++--
 linux/suspend_ioctls.h            |    4 ++--
 linux/xfrm.h                      |    2 +-
 mtd/mtd-abi.h                     |    4 ++--
 sound/asound.h                    |    4 ++--
 14 files changed, 52 insertions(+), 52 deletions(-)

The int types are a lot more:
 drm/drm.h               |   18 ++--
 drm/drm_mode.h          |  148 ++++++++++++++--------------
 drm/i915_drm.h          |  138 +++++++++++++-------------
 drm/mga_drm.h           |   16 ++--
 drm/radeon_drm.h        |    2 +-
 drm/via_drm.h           |   40 ++++----
 linux/atmlec.h          |    4 +-
 linux/atmmpc.h          |   44 +++++-----
 linux/cm4000_cs.h       |    8 +-
 linux/dlm_netlink.h     |   16 ++--
 linux/dm-ioctl.h        |   42 ++++----
 linux/dvb/audio.h       |    2 +-
 linux/dvb/video.h       |   22 ++--
 linux/if_arcnet.h       |   26 +++---
 linux/ip_vs.h           |   26 +++---
 linux/ivtvfb.h          |    2 +-
 linux/jffs2.h           |   26 +++---
 linux/matroxfb.h        |    2 +-
 linux/pfkeyv2.h         |  242 +++++++++++++++++++++++-----------------------
 linux/selinux_netlink.h |    4 +-
 linux/suspend_ioctls.h  |    2 +-
 mtd/inftl-user.h        |   36 ++++----
 mtd/jffs2-user.h        |    4 +-
 mtd/mtd-abi.h           |   64 ++++++------
 mtd/nftl-user.h         |   30 +++---
 mtd/ubi-user.h          |   70 +++++++-------
 sound/asound.h          |    2 +-
 sound/emu10k1.h         |    8 +-
 29 files changed, 523 insertions(+), 523 deletions(-)
