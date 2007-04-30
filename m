Return-Path: <linux-kernel-owner+w=401wt.eu-S1946389AbXD3Q6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946389AbXD3Q6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946392AbXD3Q6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:58:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:40475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946389AbXD3Q6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:58:30 -0400
Date: Mon, 30 Apr 2007 19:56:08 +0200
From: Andi Kleen <ak@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 09/12] i386/x86_64: EHCI usb debug port early printk support.
Message-ID: <20070430175607.GD25929@bingen.suse.de>
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com> <m18xc96eyq.fsf@ebiederm.dsl.xmission.com> <m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com> <m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com> <m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com> <m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com> <m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com> <m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com> <m1ejm14z5f.fsf_-_@ebiederm.dsl.xmission.com> <m1abwp4yd9.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1abwp4yd9.fsf_-_@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for writing that code. It should be an interesting alternative
on boxes where firescope doesn't work.

I hope I can eventually merge early firewire support code too.

On Mon, Apr 30, 2007 at 10:32:02AM -0600, Eric W. Biederman wrote:
> 
> With legacy free systems serial ports have stopped being an option
> to get early boot traces and other debug information out of a machine.

This needs a CONFIG_* at least. And some documentation on how to set it
up on both sides.

> 
> This debug device can be used to replace serial ports for
> kgdb, kdb, and console support.  And gregkh has a simple usb
> serial driver for it so user space applications that control
> serial ports should work unmodified.

But not merged yet, right? I was hoping it could be done from
user space anyways.

> For users the hard part looks like it will be finding cables and
> finding which is usb debug port 1 and realizing that there is
> flow control so the kernel boot will not happen if someone is not
> reading the serial console data.

That's nasty. Any way to work around that?

> index 92213d2..dc097aa 100644
> --- a/arch/x86_64/kernel/early_printk.c
> +++ b/arch/x86_64/kernel/early_printk.c
> @@ -3,9 +3,19 @@
>  #include <linux/init.h>
>  #include <linux/string.h>
>  #include <linux/screen_info.h>
> +#include <linux/usb/ch9.h>
> +#include <linux/pci_regs.h>
> +#include <linux/pci_ids.h>
> +#include <linux/errno.h>

Can you put it in a separate file please?
Perhaps with a little abstraction in drivers/usb ? 

> +static void dbgp_breath(void)
> +{
> +	/* Sleep to give the debug port a chance to breathe */

But you don't?

> +static __u32 __init find_dbgp(int ehci_num, unsigned *rbus, unsigned *rslot, unsigned *rfunc)

This should be probably merged into the early quirks loop

>   		early_console = &simnow_console;
>   		keep_early = 1;
> +	} else if (!strncmp(buf, "dbgp", 4)) {

usb would seem to be more intuitive

-Andi
