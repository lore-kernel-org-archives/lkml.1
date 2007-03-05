Return-Path: <linux-kernel-owner+w=401wt.eu-S965073AbXCEN1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073AbXCEN1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965131AbXCEN1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:27:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965073AbXCEN1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:27:51 -0500
Date: Mon, 5 Mar 2007 15:27:15 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305142715.GC22829@bingen.suse.de>
References: <20070305120631.GA14105@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305120631.GA14105@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 01:06:31PM +0100, Ingo Molnar wrote:
> Subject: [patch] paravirt: VDSO page is essential
> From: Ingo Molnar <mingo@elte.hu>
> 
> commit 3bbf54725467d604698721384d858b5983b87e8f disables the VDSO for 
> CONFIG_PARAVIRT kernels. This #ifdeffery was a bad change: the VDSO is 

Well it was the change that made my test machine (with SUSE 9.0 userland)
work with CONFIG_PARAVIRT on. If you have a better solution please post
it.

> an essential component of Linux, and this change forces all of them to 
> use int $0x80 - including sane ones like KVM. (If a hypervisor does not 
> handle the VDSO properly then it can work things around via the vdso=0 

No hypervisor involved, just CONFIG_PARAVIRT=y on bare hardware.

> boot option. Or CONFIG_PARAVIRT should not have been merged. But in any 
> case, it is a basic taste issue: we DO NOT #ifdef around core features 
> like this!)

We set sensible defaults for full backwards compatibility. 

-Andi
