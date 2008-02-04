Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYBDUWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYBDUWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbYBDUWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:22:39 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44196 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbYBDUWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:22:39 -0500
Date: Mon, 4 Feb 2008 21:22:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vmlinux_64.lds.S - use THREAD_SIZE instead of numeric constant
Message-ID: <20080204202241.GA16919@uranus.ravnborg.org>
References: <20080204171037.GA6743@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204171037.GA6743@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill.
On Mon, Feb 04, 2008 at 08:10:37PM +0300, Cyrill Gorcunov wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

The patch looks simple but please explain why you do what you do.
It took me some digging before I could convince mysleft this was
indeed a correct change.
And I am pretty sure you did the same investigation yourself.

A comment like:

arch/x866/kernel/inittask.c require all variables allocated in
the section .data.init_task to be aligned with THREAD_SIZE.

would have made me happy.

	Sam

> ---
> 
> Index: linux-2.6.git/arch/x86/kernel/vmlinux_64.lds.S
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/vmlinux_64.lds.S	2008-01-30 17:51:57.000000000 +0300
> +++ linux-2.6.git/arch/x86/kernel/vmlinux_64.lds.S	2008-02-03 22:38:48.000000000 +0300
> @@ -129,7 +129,7 @@ SECTIONS
>  #undef VVIRT_OFFSET
>  #undef VVIRT
>  
> -  . = ALIGN(8192);		/* init_task */
> +  . = ALIGN(THREAD_SIZE);	/* init_task */
>    .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
>  	*(.data.init_task)
>    }:data.init
