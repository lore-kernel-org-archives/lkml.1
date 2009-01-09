Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbZAIWRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbZAIWRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbZAIWQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:16:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757671AbZAIWQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:16:49 -0500
Date: Fri, 9 Jan 2009 14:16:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kobayashi.kk@ncos.nec.co.jp, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com
Subject: Re: [PATCH 2/3 v2] proc: Export statistics for softirq to /proc
Message-Id: <20090109141642.61540741.akpm@linux-foundation.org>
In-Reply-To: <20081126190603.3CC3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp>
	<20081121202708.95ec8b3f.kobayashi.kk@ncos.nec.co.jp>
	<20081126190603.3CC3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 19:10:28 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> nit
> 
> > @@ -49,6 +50,10 @@ static int show_stat(struct seq_file *p, void *v)
> >  			sum += kstat_irqs_cpu(j, i);
> >  
> >  		sum += arch_irq_stat_cpu(i);
> > +
> > +		for (j = 0; j < NR_SOFTIRQS; j++)
> > +			sum_softirq += kstat_softirqs_cpu(j, i);
> > +
> >  	}
> 
> You can calcurate per_irq_sum here.
> Typically, # of possible cpu are very big.
> 
> So, I don't like unnecessary twrice looping.

I was about to send these patches to Linus, but it seems that this
optmisation hasn't been addressed?

