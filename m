Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbXGPTyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbXGPTyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbXGPTxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:53:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757982AbXGPTxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:53:51 -0400
Date: Mon, 16 Jul 2007 12:52:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Len Brown <lenb@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 6/7] Add common orderly_poweroff()
Message-Id: <20070716125223.249a6914.akpm@linux-foundation.org>
In-Reply-To: <20070511000028.446470000@goop.org>
References: <20070510235708.155502000@goop.org>
	<20070511000028.446470000@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 16:57:14 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Various pieces of code around the kernel want to be able to trigger an
> orderly poweroff.  This pulls them together into a single
> implementation.
> 
> By default the poweroff command is /sbin/poweroff, but it can be set
> via sysctl: kernel/poweroff_cmd.  This is split at whitespace, so it
> can include command-line arguments.
> 
> This patch replaces four other instances of invoking either "poweroff"
> or "shutdown -h now": one sparc64, two sbus drivers, and acpi thermal
> management.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Acked-by: Len Brown <lenb@kernel.org>
> Cc: Chris Wright <chrisw@sous-sol.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: David S. Miller <davem@davemloft.net>
> 
> ---
>  arch/sparc64/kernel/power.c     |   40 +-------------------------
>  drivers/acpi/thermal.c          |   24 +---------------
>  drivers/sbus/char/bbc_envctrl.c |    5 +--
>  drivers/sbus/char/envctrl.c     |    7 +---
>  include/linux/reboot.h          |    5 +++
>  include/linux/sysctl.h          |    1 
>  kernel/sys.c                    |   58 +++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c                 |   10 ++++++

I'm not sure how this ended up in the x86 tree
(ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/add-common-orderly_poweroff),
but recent changes in arch/sparc64/kernel/power.c have broken it.

Dave, those changes hit mainline without ever having appeared in the
sparc-2.6.git tree, afaict.  If they _had_ appeared there I'd have been
able to tell you that there wasn't any point in changing code which we're
planning on deleting.  Otoh,

    [SPARC64]: Export powerd facilities for external entities.
    
    Besides the existing usage for power-button interrupts, we'll
    want to make use of this code for domain-services where the
    LDOM manager can send reboot requests to the guest node.

make me think that this code isn't deleteable any more.

Ho hum, I will delete the sparc64 hunk and shall hope for the best.  Mainly
to avoid downstream rejects - I suspect this patch needs revisting now.

Andi, your tree is looking pretty stale - I hope it will be updated soon?
