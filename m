Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXIDNmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXIDNmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 09:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXIDNmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 09:42:32 -0400
Received: from gw.goop.org ([64.81.55.164]:60818 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbXIDNmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 09:42:31 -0400
Message-ID: <46DD60A9.8080203@goop.org>
Date: Tue, 04 Sep 2007 14:42:01 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Zachary Amsden <zach@vmware.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] Fix preemptible lazy mode bug
References: <46CE70C8.2030005@vmware.com> <46CE8069.9070404@goop.org>	 <46CE81DC.90103@vmware.com>  <46D9D517.6010201@goop.org> <1188850468.10802.66.camel@localhost.localdomain>
In-Reply-To: <1188850468.10802.66.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>  static inline void arch_flush_lazy_mmu_mode(void)
>  {
> -	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
> +	if (unlikely(__get_cpu_var(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU))
> +		arch_leave_lazy_mmu_mode();
>  }
>   

This changes the semantics a bit; previously "flush" would flush
anything pending but leave us in lazy mode.  This just drops lazymode
altogether?

I guess if we assume that flushing is a rare event then its OK, but I
think the name's a bit misleading.  How does it differ from plain
arch_leave_lazy_mmu_mode()?

    J
