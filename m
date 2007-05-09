Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbXEIQWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbXEIQWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXEIQWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:22:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbXEIQWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:22:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] Declare {compat_}sys_utimensat
Date: Wed, 9 May 2007 18:21:58 +0200
User-Agent: KMail/1.9.6
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, paulus@samba.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070509162357.65ab8868.sfr@canb.auug.org.au>
In-Reply-To: <20070509162357.65ab8868.sfr@canb.auug.org.au>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705091821.59412.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/wyudFmjsRbjZlafY2OAE27VlGMgE84+is+V7
 8RbfcbLqfB3C3lsD4ryzpihvC5OZ3LnBMm5bZt5tJsqsYYx9iG
 +LobTBdV5rpxNW2QiwOAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2007, Stephen Rothwell wrote:
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index ccd863d..70a157a 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -253,5 +253,8 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
>                         const compat_sigset_t __user *sigmask,
>                         compat_size_t sigsetsize);
>  
> +asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename,
> +                               struct compat_timespec __user *t, int flags);
> +
>  #endif /* CONFIG_COMPAT */
>  #endif /* _LINUX_COMPAT_H */
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 1912c6c..3139f44 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -576,6 +576,8 @@ asmlinkage long sys_fstatat64(int dfd, char __user *filename,
>                                struct stat64 __user *statbuf, int flag);
>  asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *buf,
>                                int bufsiz);
> +asmlinkage long sys_utimensat(int dfd, char __user *filename,
> +                               struct timespec __user *utimes, int flags);
>  asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename,
>                                      struct compat_timeval __user *t);
>  asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,

It seems bogus to declare compat_sys_futimesat in syscalls.h and compat_sys_utimensat
in compat.h. Your patch is fine, since there are precedents for both, but maybe
we should agree on one place and then move all of the compat_sys_ declarations there.

	Arnd <><
