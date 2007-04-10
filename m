Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbXDJOHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbXDJOHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbXDJOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:07:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXDJOHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:07:05 -0400
Message-ID: <461B99D1.2010109@redhat.com>
Date: Tue, 10 Apr 2007 10:06:09 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/10] I386 mcheck p4 grotesque and needless warning fix.patch
References: <200704100006.l3A068Xk020608@zach-dev.vmware.com>
In-Reply-To: <200704100006.l3A068Xk020608@zach-dev.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> No, just no.  You do not use goto to skip a code block.  You do not
> return an obvious variable from a singly-inlined function and give
> the function a return value.  You don't put unexplained comments
> about kmalloc in code which doesn't do dynamic allocation.  And
> you don't leave stray warnings around for no good reason.
> 
> Also, when possible, it is better to use block scoped variables
> because gcc can sometime generate better code.
> 
> Signed-off-by: Zachary Amsden <zach@vmware.com>
> 
> diff -r ed741f57dae8 arch/i386/kernel/cpu/mcheck/p4.c
> --- a/arch/i386/kernel/cpu/mcheck/p4.c	Fri Apr 06 14:29:52 2007 -0700
> +++ b/arch/i386/kernel/cpu/mcheck/p4.c	Fri Apr 06 14:43:24 2007 -0700
> @@ -124,12 +124,9 @@ static void intel_init_thermal(struct cp
>  
>  
>  /* P4/Xeon Extended MCE MSR retrieval, return 0 if unsupported */
> -static inline int intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
> +static inline void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
>  {

The comment needs fixing.


