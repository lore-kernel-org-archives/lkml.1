Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbXLRVdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbXLRVdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXLRVdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:33:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXLRVdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:33:45 -0500
Message-ID: <47683B2D.9030608@zytor.com>
Date: Tue, 18 Dec 2007 13:27:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alon Bar-Lev <alon.barlev@gmail.com>
CC: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [MIPS] Build an embedded initramfs into mips kernel
References: <9e0cf0bf0712181208m7f16b9acpf3dba67f3556a613@mail.gmail.com>
In-Reply-To: <9e0cf0bf0712181208m7f16b9acpf3dba67f3556a613@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alon Bar-Lev wrote:
> Hello,
> 
> I am trying to build a basic initramfs image into the kernel, using
> the CONFIG_INITRAMFS_SOURCE. The required result is a single image
> loaded into a target containing usermode application (busybox).
> 
> I use cross compile mipsel-unknown-linux-uclibc in order to build the
> kernel and the initramfs's usermode.
> 
> The cpio image is created using cpio -o -H newc command.
> 
> The same configuration works with i586-pc-linux-uclibc cross compile.
> 
> printk at init/main.c::run_init_process() shows that the
> kernel_execve() returns -2 (ENOENT) for /init and -14 (EFAULT) for
> /*/init.
> 
> Looking at the initramfs /init is available and executable.
> 
> Any reason why I get ENOENT?
> Any special procedure should be performed for mips arch?
> 

Make sure your /init doesn't depend on an interpreter or library which 
isn't available.

	-hpa
