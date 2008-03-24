Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYCXTnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYCXTnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYCXTnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:43:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbYCXTnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:43:32 -0400
Date: Mon, 24 Mar 2008 12:42:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: corbet@lwn.net (Jonathan Corbet)
Cc: stern@rowland.harvard.edu, khali@linux-fr.org, mb@bu3sch.de,
       hmh@hmh.eng.br, david-b@pacbell.net, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mingo@elte.hu, geert@linux-m68k.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-Id: <20080324124229.5d49ded6.akpm@linux-foundation.org>
In-Reply-To: <23456.1206387289@vena.lwn.net>
References: <Pine.LNX.4.44L0.0803211343240.24421-100000@netrider.rowland.org>
	<23456.1206387289@vena.lwn.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 13:34:49 -0600
corbet@lwn.net (Jonathan Corbet) wrote:

> Discourage people from using in_atomic()
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> 
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 4982998..3d196cb 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -72,6 +72,11 @@
>  #define in_softirq()		(softirq_count())
>  #define in_interrupt()		(irq_count())
>  
> +/*
> + * Are we running in atomic context?  WARNING: this macro cannot
> + * always detect atomic context and should not be used to determine
> + * whether sleeping is possible.  Do not use it in driver code.
> + */
>  #define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)

It'd be better if the comment were to describe _why_ in_atomic() is
unreliable.  ie: "does not account for held spinlocks on non-preemptible
kernels".

