Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZC0SiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZC0SiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbZC0SiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:38:13 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42150 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZC0SiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:38:13 -0400
Date: Fri, 27 Mar 2009 19:40:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: liqin.chen@sunplusct.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 5/13] score - New architecure port to SunplusCT S+CORE processor
Message-ID: <20090327184013.GB21149@uranus.ravnborg.org>
References: <OFE9A5E3A2.37B73BA8-ON48257586.0008CFAC-48257586.00091B05@sunplusct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFE9A5E3A2.37B73BA8-ON48257586.0008CFAC-48257586.00091B05@sunplusct.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +#endif /* __SETUP_H */
> diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
> linux-2.6-git.ori/arch/score/include/asm/shmbuf.h 
> linux-2.6-git.new/arch/score/include/asm/shmbuf.h
> --- linux-2.6-git.ori/arch/score/include/asm/shmbuf.h   1970-01-01 
> 08:00:00.000000000 +0800
> +++ linux-2.6-git.new/arch/score/include/asm/shmbuf.h   2009-03-13 
> 14:26:33.000000000 +0800
> @@ -0,0 +1,29 @@
> +#ifndef _ASM_SHMBUF_H
> +#define _ASM_SHMBUF_H
> +
> +struct shmid64_ds {
> +       struct ipc64_perm       shm_perm;       /* operation perms */
> +       size_t                  shm_segsz;      /* size of segment (bytes) 
> */
> +       __kernel_time_t         shm_atime;      /* last attach time */
> +       __kernel_time_t         shm_dtime;      /* last detach time */
> +       __kernel_time_t         shm_ctime;      /* last change time */
> +       __kernel_pid_t          shm_cpid;       /* pid of creator */
> +       __kernel_pid_t          shm_lpid;       /* pid of last operator */
> +       unsigned long           shm_nattch;     /* no. of current attaches 
> */
> +       unsigned long           __unused1;
> +       unsigned long           __unused2;
> +};

This is an exported header and you mix wide specific and generic types.
The recommended way is to stick to the __[u]{32,64}int versions + the kernel
specific types as __kernel_pid_t.
In other words avoid use of int, long etc in your exported headers.

For good measure try "make headers_check" and fix all warnings.
But that will NOT find uses of int/long so here you rely on a manual process.

The above is one of several files where this is used.
See full list of arch specific headers that are exported in the file:
include/asm-generic/Kbuild.asm

	Sam
