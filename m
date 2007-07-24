Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbXGXGHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbXGXGHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXGXGHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:07:36 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49400 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbXGXGHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:07:35 -0400
Date: Tue, 24 Jul 2007 08:08:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: i386 section mismatch warnings
Message-ID: <20070724060850.GC12946@uranus.ravnborg.org>
References: <46A5536E.6010606@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A5536E.6010606@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 09:18:38PM -0400, Jeff Garzik wrote:
> make allmodconfig on i386:
> 
> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to 
> .init.text:start_kernel (between 'is386' and 'check_x87')
> WARNING: vmlinux(.text+0xc02cfcdb): Section mismatch: reference to 
> .init.text:kernel_init (between 'rest_init' and 'kthreadd_setup')
> WARNING: vmlinux(.text+0xc02d5ed2): Section mismatch: reference to 
> .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc02d5ede): Section mismatch: reference to 
> .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc02d5eea): Section mismatch: reference to 
> .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc02d5ef6): Section mismatch: reference to 
> .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc02cfda4): Section mismatch: reference to 
> .init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and 
> 'zone_wait_table_init')
> WARNING: vmlinux(.text+0xc02cfe4e): Section mismatch: reference to 
> .init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and 
> 'vgacon_scrollback_startup')
> WARNING: vmlinux(.text+0xc02d64c6): Section mismatch: reference to 
> .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.text+0xc02cfea7): Section mismatch: reference to 
> .init.text:__alloc_bootmem (between 'vgacon_scrollback_startup' and 
> 'fb_find_logo')
> WARNING: vmlinux(.text+0xc02cfecb): Section mismatch: reference to 
> .init.data:logo_linux_mono (between 'fb_find_logo' and 'schedule')
> WARNING: vmlinux(.text+0xc02cfed5): Section mismatch: reference to 
> .init.data:logo_linux_clut224 (between 'fb_find_logo' and 'schedule')
> WARNING: vmlinux(.text+0xc02cfeda): Section mismatch: reference to 
> .init.data:logo_linux_vga16 (between 'fb_find_logo' and 'schedule')
> WARNING: vmlinux(.text+0xc02d6612): Section mismatch: reference to 
> .init.text: (between 'iret_exc' and '_etext')

The above warnings happens because during final link we stuff
a lot of different sections down in a smaller number of sections.
So modpost does not know that the references are actually OK.

The fix is simply to avoid doing section mismatch check on vmlinux
when processing the modules and I have this in kbuild.git.
I expect this to be merged during -rc1 (was sent in the merge window
but did not get applied).

As a general rule just ignore all section mismatch warnings that originate
from vmlinux. The others needs to be fixed and there seem to be enough
to deal with :-(

	Sam
