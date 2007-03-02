Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbXCBA63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbXCBA63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXCBA63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:58:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:32821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXCBA62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:58:28 -0500
Date: Thu, 1 Mar 2007 16:47:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, linux-dvb@linuxtv.org, domi.dumont@free.fr,
       Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: patch 3 / 3: fix floppy mount bug in kernel 2.6.21-rc1
Message-Id: <20070301164742.d9be02d7.akpm@linux-foundation.org>
In-Reply-To: <20070301143222.263070@gmx.net>
References: <20070301143222.263070@gmx.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 15:32:22 +0100
"Uwe Bugla" <uwe.bugla@gmx.de> wrote:

> Hi folks,
> this patch fixes the floppy mount bug (i. e. regression) in kernel 2.6.21-rc1. It was inspired by Stephane Eranian. It was tested on an Intel P4 1800 MHz
> (Intel ICH4 chipset) and on an AMD Athlon XP 1800 MHz (Silicon Integrated Systems chipset 740, 5513).
> My deep thanks and respect go to:
> Stephane Eranian, Linus Torvalds, Jiri Slaby. You are truthfully real men and reliable, accurate, fine chaps. It feels great to have you in this world-wide community!
> Would you still call the whole i386 architecture "a small number of machines", Mister Andrew Morton? If yes, in how far please?
> 
> Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>
> 
> --- a/arch/i386/kernel/process.c
> +++ b/arch/i386/kernel/process.c
> @@ -154,6 +154,7 @@
>  		current_thread_info()->status |= TS_POLLING;
>  	} else {
>  		/* loop is done by the caller */
> +		local_irq_enable();
>  		cpu_relax();
>  	}
>  }

Linus reverted the offending patch "[PATCH] i386: add idle notifier"
on Feb 26, so this fix should no longer be needed, and 2.6.21-rc2 should
be working again.

Hopefully Stephane will fold this fix into any future version of that patch,
if appropriate.
