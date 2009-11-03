Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbZKCXtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbZKCXtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZKCXtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:49:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbZKCXtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:49:14 -0500
Date: Tue, 3 Nov 2009 15:48:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Subject: [PATCH] rtc: Explicitly set llseek to no_llseek
Message-Id: <20091103154800.f7f6ef5f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0910212312270.3526@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de>
	<20091010153350.046644063@linutronix.de>
	<alpine.LFD.2.00.0910212312270.3526@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 23:13:26 +0200 (CEST)
John Kacur <jkacur@redhat.com> wrote:

> >From e1b7175258b33da3b0564ef04a0b1956f04f0cc7 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Wed, 21 Oct 2009 23:10:30 +0200
> Subject: [PATCH] rtc: Explicitly set llseek to no_llseek
> 
> Now that we've removed the BKL here, lets explicitly set llseek to no_llseek
> since the default llseek is not used here.
> 

I don't understand.

> 
> diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
> index 26a47dc..53c524e 100644
> --- a/drivers/char/efirtc.c
> +++ b/drivers/char/efirtc.c
> @@ -285,6 +285,7 @@ static const struct file_operations efi_rtc_fops = {
>  	.unlocked_ioctl	= efi_rtc_ioctl,
>  	.open		= efi_rtc_open,
>  	.release	= efi_rtc_close,
> +	.llseek		= no_llseek,
>  };
>  
>  static struct miscdevice efi_rtc_dev= {

What has this change to do with the BKL?
