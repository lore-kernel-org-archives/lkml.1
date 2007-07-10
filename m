Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXGJNCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXGJNCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbXGJNCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:02:32 -0400
Received: from mail.trixing.net ([87.230.125.58]:57414 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbXGJNCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:02:31 -0400
Message-ID: <46938363.2000007@l4x.org>
Date: Tue, 10 Jul 2007 15:02:27 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: mingo@elte.hu
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200707092059.l69Kx1kb026264@hera.kernel.org>
In-Reply-To: <200707092059.l69Kx1kb026264@hera.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: sched: rename idle_type/SCHED_IDLE
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d15bcfdbe1818478891d714343f037cfe60875f0
> Commit:     d15bcfdbe1818478891d714343f037cfe60875f0
> Parent:     7dcca30a32aadb0520417521b0c44f42d09fe05c
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Mon Jul 9 18:51:57 2007 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon Jul 9 18:51:57 2007 +0200
> 
>     sched: rename idle_type/SCHED_IDLE
>     
>     enum idle_type (used by the load-balancer) clashes with the
>     SCHED_IDLE name that we want to introduce. 'CPU_IDLE' instead
>     of 'SCHED_IDLE' is more descriptive as well.

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -639,12 +639,11 @@ static inline int sched_info_on(void)
>  #endif
>  }
>  
> -enum idle_type
> -{
> -	SCHED_IDLE,
> -	NOT_IDLE,
> -	NEWLY_IDLE,
> -	MAX_IDLE_TYPES
> +enum cpu_idle_type {
> +	CPU_IDLE,
> +	CPU_NOT_IDLE,
> +	CPU_NEWLY_IDLE,
> +	CPU_MAX_IDLE_TYPES
>  };
>  
>  /*

This broke s390:

  GEN     /tmp/tmp.qnrRZ13800/out/s390/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-s390
  CC      arch/s390/kernel/asm-offsets.s
In file included from
/tmp/tmp.qnrRZ13800/kernel/arch/s390/kernel/asm-offsets.c:7:
/tmp/tmp.qnrRZ13800/kernel/include/linux/sched.h:641: error: syntax
error before numeric constant
make[2]: *** [arch/s390/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [_all] Error 2
  CLEAN   .tmp_versions


Jan
