Return-Path: <linux-kernel-owner+w=401wt.eu-S1946417AbXBCJeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946417AbXBCJeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 04:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946420AbXBCJeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 04:34:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:45491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946417AbXBCJeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 04:34:03 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-rc7: known regressions
Date: Sat, 3 Feb 2007 10:33:42 +0100
User-Agent: KMail/1.9.5
Cc: =?iso-8859-1?q?Fr=E9d=E9ric_Riss?= <frederic.riss@gmail.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <1170494391.31373.25.camel@funkylaptop> <20070203012426.120ec586.akpm@linux-foundation.org>
In-Reply-To: <20070203012426.120ec586.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702031033.42940.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  /*
> + * Wrap all the virtual calls in a way that forces the parameters on the stack.
> + */
> +
> +#define efi_call_virt(f, args...) \
> +     ((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
> +
> +static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
> +{
> +	return efi_call_virt(get_time, tm, tc);

Wouldn't it be better to just declare the pointers in efi.systab with 
the correct attribute?  Then you wouldn't need all that ugly casting.

-Andi
