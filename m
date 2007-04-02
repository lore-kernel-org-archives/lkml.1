Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXDBFuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXDBFuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXDBFuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:50:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36620 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXDBFuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:50:54 -0400
Date: Sun, 1 Apr 2007 22:50:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] enhance initcall_debug, measure latency
Message-Id: <20070401225039.c3f65841.akpm@linux-foundation.org>
In-Reply-To: <20070401181614.GA25648@elte.hu>
References: <20070401181614.GA25648@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:16:14 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> +		if (initcall_debug) {
> +			t1 = ktime_get();
> +			delta = ktime_sub(t1, t0);
> +
> +			printk("initcall 0x%p", *call);
> +			print_fn_descriptor_symbol(": %s()",
> +					(unsigned long) *call);
> +			printk(" returned %d.\n", result);
> +
> +			printk("initcall 0x%p ran for %Ld msecs: ",
> +				*call, delta.tv64 >> 20);
> +			print_fn_descriptor_symbol("%s()\n",
> +				(unsigned long) *call);
> +		}

This might come out a bit better if it were to use -mm's
sprint_symbol().
