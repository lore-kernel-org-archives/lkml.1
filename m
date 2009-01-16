Return-Path: <linux-kernel-owner+w=401wt.eu-S936011AbZAPReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936011AbZAPReS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbZAPReB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:34:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbZAPRd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:33:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 3/5] Add preadv and pwritev system calls.
Date: Fri, 16 Jan 2009 18:34:01 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org, aarcange@redhat.com
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <1232124344-25892-4-git-send-email-kraxel@redhat.com>
In-Reply-To: <1232124344-25892-4-git-send-email-kraxel@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901161834.02481.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+qfBnmmipG+AKUUn6IlUbDtEo2IVu2+4A2ia+
 Xi2y4IuPK3hK58QpXB9g+gbu9riR+cXSKlMirqhrrb/ZlM04/d
 dZWTWoINCQ1iEAXVPrHaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Gerd Hoffmann wrote:
> +asmlinkage ssize_t compat_sys_preadv(unsigned long fd,
> +               const struct compat_iovec __user *vec,
> +               unsigned long vlen, u32 pos_high, u32 pos_low);
> +asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
> +               const struct compat_iovec __user *vec,
> +               unsigned long vlen, u32 pos_high, u32 pos_low);
>  
>  int compat_do_execve(char * filename, compat_uptr_t __user *argv,
>                 compat_uptr_t __user *envp, struct pt_regs * regs);
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 16875f8..333377e 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -456,6 +456,10 @@ asmlinkage long sys_pread64(unsigned int fd, char __user *buf,
>                             size_t count, loff_t pos);
>  asmlinkage long sys_pwrite64(unsigned int fd, const char __user *buf,
>                              size_t count, loff_t pos);
> +asmlinkage long sys_preadv(unsigned long fd, const struct iovec __user *vec,
> +                           unsigned long vlen, u32 pos_high, u32 pos_low);
> +asmlinkage long sys_pwritev(unsigned long fd, const struct iovec __user *vec,
> +                            unsigned long vlen, u32 pos_high, u32 pos_low);

Conventionally, the 'fd' argument has type 'int', not 'unsigned long', but you
evidently copied this from readv/writev, so you can't really be blamed for it.
Not sure what the right thing to do here is.

	Arnd <><
