Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYAHUFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYAHUFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYAHUFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:05:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbYAHUFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:05:30 -0500
Date: Tue, 8 Jan 2008 15:04:39 -0500
From: Rik van Riel <riel@redhat.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in
 arch/x86/ia32/ia32_aout.c
Message-ID: <20080108150439.6388028e@bree.surriel.com>
In-Reply-To: <20080108203233.01bb5c7f@paolo-desktop>
References: <20080108203233.01bb5c7f@paolo-desktop>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 20:32:33 +0100
Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Fix plenty of coding style errors

Most of these kernel changes would probably get in the way of
real development, making patches reject that would otherwise
apply.

You did find one possible bug, though:

> @@ -467,9 +465,9 @@ static int load_aout_library(struct file *file)
>  
>  #ifdef WARN_OLD
>  		static unsigned long error_time;
> -		if ((jiffies-error_time) > 5*HZ)
> -		{
> -			printk(KERN_WARNING 
> +		if ((jiffies-error_time) > 5*HZ) {
> +
> +			printk(KERN_WARNING
>  			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
>  			       file->f_path.dentry->d_name.name);
>  			error_time = jiffies;

You may want to look into the time_after() macro and make sure
it is used here.

-- 
All rights reversed.
