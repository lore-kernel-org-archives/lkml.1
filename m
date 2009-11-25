Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbZKYDWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbZKYDWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934028AbZKYDWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:22:51 -0500
Received: from ozlabs.org ([203.10.76.45]:32896 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933781AbZKYDWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:22:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19212.41571.997709.92207@cargo.ozlabs.ibm.com>
Date: Wed, 25 Nov 2009 14:20:03 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs cpu probe/release files
In-Reply-To: <4B0C8D46.1030206@austin.ibm.com>
References: <4B0C8B45.6080804@austin.ibm.com>
	<4B0C8D46.1030206@austin.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot writes:

> Create new probe and release sysfs files to facilitate adding and removing
> cpus from the system.  This also creates the powerpc specific stubs to handle
> the arch callouts from writes to the sysfs files.
> 
> The creation and use of these files is regulated by the 
> CONFIG_ARCH_CPU_PROBE_RELEASE option so that only architectures that need the
> capability will have the files created.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> ---
>  arch/powerpc/Kconfig               |    4 ++++
>  arch/powerpc/include/asm/machdep.h |    5 +++++
>  arch/powerpc/kernel/sysfs.c        |   19 +++++++++++++++++++
>  drivers/base/cpu.c                 |   32 ++++++++++++++++++++++++++++++++

Since this touches drivers/base/cpu.c, you should cc Greg KH on this
patch and get an ack from him, assuming these patches are going in
through the powerpc tree.

> --- powerpc.orig/include/linux/cpu.h	2009-11-23 18:19:23.000000000 -0600
> +++ powerpc/include/linux/cpu.h	2009-11-24 14:30:07.000000000 -0600
> @@ -43,6 +43,10 @@
>  
>  #ifdef CONFIG_HOTPLUG_CPU
>  extern void unregister_cpu(struct cpu *cpu);
> +#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
> +extern ssize_t arch_cpu_probe(const char *, size_t);
> +extern ssize_t arch_cpu_release(const char *, size_t);
> +#endif

Since these are just declarations, they don't need the #ifdef around
them.

Paul.
