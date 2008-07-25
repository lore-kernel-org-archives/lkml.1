Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYGYVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYGYVu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYGYVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:49:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbYGYVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:49:50 -0400
Date: Fri, 25 Jul 2008 14:49:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [patch 2.6.26-git] pm selftest:  rtc paranoia
Message-Id: <20080725144946.5e1b78c8.akpm@linux-foundation.org>
In-Reply-To: <200807251326.51987.david-b@pacbell.net>
References: <200807251326.51987.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 13:26:51 -0700
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Cope with a quirk of some RTCs (notably ACPI ones) which
> aren't guaranteed to implement oneshot behavior when they
> woke the system from sleeep:  forcibly disable the alarm,
> just in case.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  kernel/power/main.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --- a/kernel/power/main.c	2008-07-22 16:38:32.000000000 -0700
> +++ b/kernel/power/main.c	2008-07-22 16:39:15.000000000 -0700
> @@ -635,6 +635,13 @@ static void __init test_wakealarm(struct
>  	}
>  	if (status < 0)
>  		printk(err_suspend, status);
> +
> +	/* Some platforms can't detect that the alarm triggered the
> +	 * wakeup, or (accordingly) disable it after it afterwards.
> +	 * It's supposed to give oneshot behavior; cope.
> +	 */
> +	alm.enabled = false;
> +	rtc_set_alarm(rtc, &alm);
>  }
>  
>  static int __init has_wakealarm(struct device *dev, void *name_ptr)

I assume this fixes some reported bug?  Any references?

Is this needed in 2.6.26.x?  2.6.25.x?
