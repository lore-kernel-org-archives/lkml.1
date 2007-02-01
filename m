Return-Path: <linux-kernel-owner+w=401wt.eu-S1422813AbXBALg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbXBALg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422823AbXBALgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:36:36 -0500
Received: from ns1.suse.de ([195.135.220.2]:60013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422815AbXBALgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:31 -0500
From: Andi Kleen <ak@suse.de>
To: jbohac@suse.cz
Subject: Re: [patch 8/9] Add time_update_mt_guess()
Date: Thu, 1 Feb 2007 12:28:50 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201103754.136630000@jet.suse.cz>
In-Reply-To: <20070201103754.136630000@jet.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011228.50435.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 11:00, jbohac@suse.cz wrote:

> Index: linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
> ===================================================================
> --- linux-2.6.20-rc5.orig/arch/x86_64/kernel/apic.c
> +++ linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
> @@ -63,6 +63,9 @@ int using_apic_timer __read_mostly = 0;
>  
>  static void apic_pm_activate(void);
>  
> +extern void time_update_mt_guess(void);

No externs in .c files


> +inline u64 mt_to_nsec(u64 mt)
> +{
> +	u64 ret;
> +	ret  = ((mt & 0xffffff) * vxtime.mt_q) >> 32;
> +	mt >>= 24;
> +	ret += ((mt & 0xffffff) * vxtime.mt_q) >> 8;
> +	mt >>= 24;
> +	ret += ( mt             * vxtime.mt_q) << 16;
> +	return ret;

Why so complicated? Isn't a single multiply good enough?

-Andi
