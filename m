Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYKVBff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYKVBff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYKVBf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:35:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756742AbYKVBfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:35:25 -0500
Date: Fri, 21 Nov 2008 17:35:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/3] proc: Export statistics for softirq to /proc
Message-Id: <20081121173518.5ffe3a9e.akpm@linux-foundation.org>
In-Reply-To: <20081121170743.cd30b01e.kobayashi.kk@ncos.nec.co.jp>
References: <20081120195542.c85d4967.kobayashi.kk@ncos.nec.co.jp>
	<20081120195843.c6d0b653.kobayashi.kk@ncos.nec.co.jp>
	<20081120210923.cfb90561.akpm@linux-foundation.org>
	<20081121170743.cd30b01e.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 17:07:43 -0800 Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp> wrote:

> > This uses for_each_online_cpu(), but below we use for_each_possible_cpu().
> > 
> > Shouldn't we be consistent here so that at least the numbers will add
> > up to the same thing?
> > 
> > Probably for_each_possible_cpu() is best - people might want to see how
> > many softirqs happened on a CPU which was recently offlined.
> 
> I understand this point. I'll fix it later.
> 
> There is same problem regarding /proc/interrupts.
> Should we change from for_each_online_cpu() to for_each_possible_cpu(),
> or is it too late?

I assume that /proc/interrupts has been that way for a very long time,
and nobody has noticed&complained.  If we can find anyone who actually
uses cpu hotplug then perhaps they could help us out here.  But such
people seem to be rare.

I dunno.  I guess we can leave /proc/interrupts alone.
