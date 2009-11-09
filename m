Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZKIJPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZKIJPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZKIJPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:15:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:38589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbZKIJPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:15:11 -0500
Subject: Re: specjbb2005 and aim7 regression with 2.6.32-rc kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1257750573.6414.29.camel@marge.simson.net>
References: <1257493130.16282.109.camel@ymzhang>
	 <20091106080418.GB28227@elte.hu>  <1257747597.16282.120.camel@ymzhang>
	 <1257750573.6414.29.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 10:15:04 +0100
Message-ID: <1257758104.4108.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 08:09 +0100, Mike Galbraith wrote:
> +       smp_read_barrier_depends();
>         cpumask_setall(cpus);
> +       cpumask_and(cpus, cpus, cpu_online_mask);


how about: cpumask_copy(cpus, cpu_online_mask); ?

Also, iirc cpu_online_mask is guaranteed stable when preemption is
disabled, otherwise you need to use get/put_online_cpus(), an
rmb_depends() won't do.

