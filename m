Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbXDLThO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbXDLThO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXDLThO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:37:14 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56528 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbXDLThM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:37:12 -0400
Date: Thu, 12 Apr 2007 12:37:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add keyboard blink driver
Message-Id: <20070412123704.62963654.akpm@linux-foundation.org>
In-Reply-To: <200704122128.08869.ak@novell.com>
References: <200704121727.27892.ak@novell.com>
	<20070412121028.d7e5c4b6.akpm@linux-foundation.org>
	<200704122128.08869.ak@novell.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 21:28:08 +0200
Andi Kleen <ak@novell.com> wrote:

> > I wonder if this facility would be more effective if it were to use
> > schedule_delayed_work().  That way, we're using more of the kernel and it
> > will more reliably detect kernel deadness.
>  
> Hmm, maybe

??

> +static void do_blink(unsigned long data)
> +{
> +	static long count;
> +	if (panic_blink)
> +		panic_blink(count++);
> +	blink_timer.expires = jiffies + msecs_to_jiffies(1);
> +	add_timer(&blink_timer);
> +}
> +
> +static int blink_init(void)
> +{
> +	printk(KERN_INFO "Enabling keyboard blinking\n");
> +	do_blink(0);
> +	return 0;
> +}

Would it be better to just not start the timer at all if panic_blink==0? 
That would improve life rather a lot for people who link this into vmlinux
but don't have i8042.

