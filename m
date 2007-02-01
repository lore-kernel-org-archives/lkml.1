Return-Path: <linux-kernel-owner+w=401wt.eu-S1422819AbXBALgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422819AbXBALgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422817AbXBALgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:36:32 -0500
Received: from ns1.suse.de ([195.135.220.2]:60007 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422813AbXBALgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:31 -0500
From: Andi Kleen <ak@suse.de>
To: jbohac@suse.cz
Subject: Re: [patch 7/9] Adapt the time initialization code
Date: Thu, 1 Feb 2007 12:26:33 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201103754.041245000@jet.suse.cz>
In-Reply-To: <20070201103754.041245000@jet.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011226.33339.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +extern void time_initialize_cpu(void);

Never put externs into .c files. Multiple occurrences.


> +void time_initialize_cpu(void *info)
> +{
> +	unsigned long flags;
> +	int cpu = smp_processor_id();

Are you sure this can never preempt? 

> +	/* FIXME: what speed does the cpu really start at; I doubt cpu_khz is right at this point ??!!!

It should be. It comes from measurements. Unless the CPU changes frequency
behind the kernel's back, but there is nothing that can be done then.

-Andio
