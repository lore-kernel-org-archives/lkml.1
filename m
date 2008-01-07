Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbYAGSIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbYAGSIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 13:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYAGSIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 13:08:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959AbYAGSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 13:08:11 -0500
Date: Mon, 7 Jan 2008 10:07:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bunk@kernel.org,
       clameter@sgi.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build-Failure at
 __you_cannot_kmalloc_that_much
Message-Id: <20080107100733.3655f74f.akpm@linux-foundation.org>
In-Reply-To: <478200A4.4090707@linux.vnet.ibm.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<478200A4.4090707@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jan 2008 16:06:20 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> The defconfig make fails on x86_64 (AMD box) with following error
> 
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o(.init.text+0x8d76): In function `dmi_id_init':
> : undefined reference to `__you_cannot_kmalloc_that_much'
> make: *** [.tmp_vmlinux1] Error 1
> 
> 
> # gcc --version
> gcc (GCC) 3.2.3 20030502 (Red Hat Linux 3.2.3-59)
> 
> This was reported by Adrian Bunk http://lkml.org/lkml/2007/12/1/39

That's odd.  afacit the only kmalloc in dmi_id_init() is

        dmi_dev = kzalloc(sizeof(*dmi_dev), GFP_KERNEL);

and even gcc-3.2.3 should be able to get that right.

Could you please a) verify that simply removing that line fixes the build
error and then b) try to find some way of fixing it?

Try replacing `sizeof(*dmi_dev)' with `sizeof(struct dmi_device_attribute)'
and any other tricks you can think of to try to make the compiler process
the code differently.

