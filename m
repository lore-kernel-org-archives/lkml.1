Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXHTIBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXHTIBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXHTIBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:01:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXHTIBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:01:24 -0400
Message-ID: <46C94A48.4060309@redhat.com>
Date: Mon, 20 Aug 2007 10:01:12 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
CC: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Early printk behaviour
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <8bd0f97a0708160947x3bd308abmc4f3b523e2444586@mail.gmail.com> <46C552FB.4000508@redhat.com> <200708171700.29647.rgetz@blackfin.uclinux.org>
In-Reply-To: <200708171700.29647.rgetz@blackfin.uclinux.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:

>> Hmm, yes, should be doable in generic code.  Check whenever the current
>> console has CON_BOOT set and if so unregister it.
> 
> Something like:
> 
> +++ kernel/printk.c     (working copy)
> +int __init disable_boot_consoles(void)
> +{
> +       struct console *con;
> +
> +       for (con = console_drivers; con; con = con->next) {
> +               if (con->flags & CON_BOOT) {
> +                       printk(KERN_INFO "Unregister BootConsole %s%d\n",
> +                               con->name, con->index);
> +                       unregister_console(con);
> +               }
> +       }
> +       return 0;
> +}
> +late_initcall(disable_boot_consoles);

Yep, that should work.  You can drop the loop though.  You can't
register a boot console if another console exists, and the first
non-boot console replaces the boot console, thus you never ever have
more than one console in case the boot console is still active.

The printk should be all lowercase like the other printk's in the file.

Other than that it loosk fine.

cheers,
  Gerd

