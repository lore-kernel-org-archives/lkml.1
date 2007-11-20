Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbXKTGbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbXKTGbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXKTGbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:31:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbXKTGbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:31:10 -0500
Date: Mon, 19 Nov 2007 22:31:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk.c: use ints instead of longs for logbuf index
Message-Id: <20071119223107.36e85982.akpm@linux-foundation.org>
In-Reply-To: <200711181932.12588.vda.linux@googlemail.com>
References: <200711181932.12588.vda.linux@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007 19:32:12 -0800 Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Subject: [PATCH] printk.c: use ints instead of longs for logbuf index

"unsigned ints".  It matters - using ints would fill the code with bugs.

> Date: Sun, 18 Nov 2007 19:32:12 -0800
> User-Agent: KMail/1.9.1
> 
> Hi Andrew,
> 
> This patch stops using unsigned _longs_ for printk
> buffer indexes. Log buffer is way smaller than 2 gigabytes
> and unsigned ints will work too . Indeed, they do work nicely
> on all 32-bit platforms where longs and ints are the same.
> 
> With this patch, we have following size savings on amd64:
> 
>    text    data     bss     dec     hex filename
>    5997     313   17736   24046    5dee 2.6.23.1.t64/kernel/printk.o
>    5858     313   17700   23871    5d3f 2.6.23.1.printk.t64/kernel/printk.o

I can imagine someone using an 8GB log buffer for crazy
i-cant-be-bothered-using-relayfs stuff.

Oh well, they'll live.
