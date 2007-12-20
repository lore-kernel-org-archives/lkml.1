Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbXLTJQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbXLTJQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbXLTJQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:16:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51354 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbXLTJQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:16:24 -0500
Date: Thu, 20 Dec 2007 09:16:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pierre Savary <pierre.savary@kerlink.fr>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: syscall in a module
Message-ID: <20071220091605.GC7921@flint.arm.linux.org.uk>
References: <000001c842e7$3f2cd340$bd8679c0$@savary@kerlink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001c842e7$3f2cd340$bd8679c0$@savary@kerlink.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 10:03:53AM +0100, Pierre Savary wrote:
> I need some help about syscalls and modules. In fact I want to adapt the
> g_file_storage module to my own application.
> I need to use "sys_umount" and "sys_mount" but when I compile I obtain this
> message :
> [...]
>   Kernel: arch/arm/boot/zImage is ready
>   Building modules, stage 2.
>   MODPOST 4 modules
> ERROR: "sys_umount" [drivers/usb/gadget/g_file_storage.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> [...]
> 
> So, how can I use "sys_umount" and "sys_mount" in this module?

You don't.  Syscalls are NOT for modules because they modify the
filesystem, which depends on the user context.  For example, processes
running chroot have a different view of the filesystem from those which
aren't - and if you happen to be executing with the context of a
chrooted user process when you mount, and a non-chrooted process when
you umount.

I suggest you describe what you're trying to do in greater detail, and/or
ask on the main kernel list - but note that if you ask the same question
without explaining why you need it _and_ asking for alternative ideas,
you'll get the same kind of response there.
