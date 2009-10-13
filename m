Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbZJMXfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbZJMXfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZJMXfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:35:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbZJMXe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:34:59 -0400
Date: Tue, 13 Oct 2009 16:34:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas DuBuisson <thomas.dubuisson@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Include hrtimer.h for ANSI compliance
Message-Id: <20091013163414.62ec9244.akpm@linux-foundation.org>
In-Reply-To: <4c44d90b0910061520o36adc7m50419be3a3d9d0fa@mail.gmail.com>
References: <4c44d90b0910061520o36adc7m50419be3a3d9d0fa@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 15:20:16 -0700
Thomas DuBuisson <thomas.dubuisson@gmail.com> wrote:

> Include <linux/hrtimer.h> to make pci.h ansi compliant (it references
> an hrtimer enum).

extern enum hrtimer_restart it_real_fn(struct hrtimer *);


Perhaps the declaration of it_real_fn() should be moved to hrtimer.h
instead.  Or perhaps not.


Or we could "forward declare" the enum with simply

enum hrtimer_restart;

but given that the compiler works out the storage size of the type at
compile-time, that looks risky.


Or we could not do anything.  Because increasing our inclusion
complexity for no known gain isn't a bargain.


Or is it no known gain?  What prompted you to write this patch?  Some
error message or warning from some tool?  If so, please describe it
fully.

> 
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index a2d1eb6..ad2b3cb 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -6,6 +6,7 @@
> #include <linux/stddef.h>
> #include <linux/debugobjects.h>
> #include <linux/stringify.h>
> +#include <linux/hrtimer.h>
> 
> struct tvec_base;

Your email client mangles whitespace, thus destroying the patch.
