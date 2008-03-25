Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYCYQow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYCYQow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbYCYQoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:44:44 -0400
Received: from www.tglx.de ([62.245.132.106]:40519 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbYCYQon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:44:43 -0400
Date: Tue, 25 Mar 2008 17:44:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/7] Split large page mapping for AMD TSEG
In-Reply-To: <20080312025332.B5DFC1B41D1@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803251723300.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025332.B5DFC1B41D1@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Andi Kleen wrote:
> +
> +	if (!direct_gbpages &&
> +		c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
> +		unsigned long tseg;

Can we do this at some place which is only called once ?

> +		/*
> +		 * Split up direct mapping around the TSEG SMM area.
> +		 * Don't do it for gbpages because there seems very little
> +		 * benefit in doing so.
> +		 */
> +		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg) &&

 warning: passing argument 2 of 'rdmsrl_safe' from incompatible pointer type  

Thanks,

	tglx
