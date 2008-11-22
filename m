Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYKVBHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYKVBHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYKVBHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:07:44 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:43697 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbYKVBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:07:44 -0500
Date: Fri, 21 Nov 2008 17:07:43 -0800
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/3] proc: Export statistics for softirq to /proc
Message-Id: <20081121170743.cd30b01e.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20081120210923.cfb90561.akpm@linux-foundation.org>
References: <20081120195542.c85d4967.kobayashi.kk@ncos.nec.co.jp>
	<20081120195843.c6d0b653.kobayashi.kk@ncos.nec.co.jp>
	<20081120210923.cfb90561.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/*
> > + * /proc/softirqs  ... display the number of softirqs
> > + */
> > +static int show_softirqs(struct seq_file *p, void *v)
> > +{
> > +	int i, j;
> > +
> > +	seq_printf(p, "                ");
> > +	for_each_online_cpu(i)
> > +		seq_printf(p, "CPU%-8d", i);
> > +	seq_printf(p, "\n");
> > +
> > +	for_each_softirq_nr(i) {
> > +		seq_printf(p, "%-10s", desc_array[i]);
> > +		for_each_online_cpu(j)
> > +			seq_printf(p, "%10u ", kstat_softirqs_cpu(i, j));
> > +		seq_printf(p, "\n");
> > +	}
> > +	return 0;
> > +}
> 
> This uses for_each_online_cpu(), but below we use for_each_possible_cpu().
> 
> Shouldn't we be consistent here so that at least the numbers will add
> up to the same thing?
> 
> Probably for_each_possible_cpu() is best - people might want to see how
> many softirqs happened on a CPU which was recently offlined.

I understand this point. I'll fix it later.

There is same problem regarding /proc/interrupts.
Should we change from for_each_online_cpu() to for_each_possible_cpu(),
or is it too late?
