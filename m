Return-Path: <linux-kernel-owner+w=401wt.eu-S932513AbZHLKoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbZHLKoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbZHLKoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:44:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54348 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbZHLKoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:44:12 -0400
To: april <aapril03@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is compat_sys_ioctl called when both kernel and userland are 64bit ?
From: Andi Kleen <andi@firstfloor.org>
References: <d67deb790908120227s7816a02cr1ea173a4358fa301@mail.gmail.com>
Date: Wed, 12 Aug 2009 12:44:11 +0200
In-Reply-To: <d67deb790908120227s7816a02cr1ea173a4358fa301@mail.gmail.com> (april's message of "Wed, 12 Aug 2009 17:27:27 +0800")
Message-ID: <87skfxfh1g.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

april <aapril03@gmail.com> writes:
>
> it seems when a kernel is built to x86_64, whenever a ioctl called
> ,the call flow will be ia32_syscall -->compat_sys_ioctl->compat
> ioctl(if provided)

Only for syscalls throught int 0x80 (or 32bit SYSCALL/SYSENTER), which normally 
only come from 32bit processes. In theory 64bit processes
could use them, but they normally don't.

> but I have some doubt:
>
> My question is:
> 1.  Is compat_sys_ioctl called when both kernel and userland are 64bit
> (suppose I provide those compat ioctl functions)?

No.

>      If not, how kernel knows the driver is 32bit or 64bit?

There are no 32bit drivers on a 64bit kernel, all drivers are 64bit.

For 32bit processes running on a 64bit kernel it depends on the 
entry points (int 0x80 or SYSENTER/SYSCALL)

> 2. when using mmap, the 64bit kernel will return a 64bit address, and
> a userland(32bit) application can only get the lower 32bit,
> it can work when the memory is not large.

The kernel makes sure to only hand out 32bit addresses to 32bit
processes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
