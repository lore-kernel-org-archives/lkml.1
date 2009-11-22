Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZKVCch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZKVCch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 21:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZKVCch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 21:32:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:36770 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbZKVCcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 21:32:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LIabKhQD2EN9INxT/tBUKBU3CCLtc2n+5imRmus/vKxjMNdkLc2nY7lMtf8zhkrCts
         l1SpTZzzthCJiIDv9nHICd7stb3pndMnyfvJy2CdOyp8hsEiSRqCI36tHKmcTDwsW4oI
         C7brhUBpvJUTgF1MIeSYxnY3j5onaoVI+yYb8=
Date: Sun, 22 Nov 2009 03:32:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Put printk buffer in video ram
Message-ID: <20091122023237.GA6572@nowhere>
References: <1258855506.3153.1.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258855506.3153.1.camel@maxim-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 04:05:06AM +0200, Maxim Levitsky wrote:
> After doing some successful debugging by placing printk buffer in video
> ram, here I publish cleaned version of it.
> 
> I discovered that on my system video ram isn't cleared on reboot, and I
> took advantage of that by placing printk buffer directly there.
> This allows to capture oopses/panicks almost from everywhere.
> It is also very simple to setup.
> 
> 
> Best regards,
> Maxim Levitsky
> 
> ---
> 
> >From 77e0f4ffc531417d54ce928ade8481d82192b012 Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Sun, 22 Nov 2009 03:49:04 +0200
> Subject: [PATCH] printk: Allow to store log buffer into video memory
> 
> This patch adds new kernel parameter printk_address=
> that will allow it to store the printk buffer in arbitary
> (I/O) memory address.
> 
> If you own a system that has discrete video ram, and it
> isn't cleared automatically by BIOS on reboot, you
> can use this as a black box recorder of crashes.
> 
> If debugfs is enabled, log of last boot is copied into
> system ram, and can be accessed via debugfs, for example
> cat /sys/kernel/debug/printk/crash_dmesg
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  kernel/printk.c   |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug |   31 ++++++++++++++++
>  2 files changed, 133 insertions(+), 0 deletions(-)



kernel/printk.c does not seem to be the right place to do that
but rather in a specific console driver.
I would rather see it as an early console (for early printk), beside ttyS,
vga and usb debug ports.

Also, instead of creating another debugfs entry, you could just
trigger the trace to the ftrace ring buffer, using trace_printk()
for example.

Hm?

I personally would like to see such feature as I have no serial line
in my laptop, although I'm not sure my graphical card would be happy
with that...

Thanks.

