Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYKFWVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYKFWVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYKFWU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:20:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYKFWU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:20:58 -0500
Date: Thu, 6 Nov 2008 23:20:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       "Christopher S. Aker" <caker@theshore.net>,
       xen devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] 2.6.27 - SMP enabled, but only 1 CPU
Message-ID: <20081106222039.GA7505@elte.hu>
References: <48F3BC99.5040409@theshore.net> <490F5F50.7020704@theshore.net> <4910AD00.7040605@theshore.net> <4911BC52.7040905@theshore.net> <1225994697.12607.837.camel@zakaz.uk.xensource.com> <49134257.4000404@goop.org> <20081106211639.GA24579@elte.hu> <49136168.3040604@goop.org> <20081106213344.GF24579@elte.hu> <49136628.1020000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49136628.1020000@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> where exactly is that use? My grep didnt show any users of pud_page().  
>> pud_page() was changed in an incompatible way, all users of it must be  
>> updated.
>>   
>
> pgd_page() uses it in pgtable-nopud.h, so any users of pgd_page() 
> also need to be looked at.  It so happens the only user is 
> arch/x86/xen/mmu.c, which expects it to return the vaddr.  Fixed 
> below.

ah! asm-generic was missed by my grep. (and i suspect Jan missed it 
too)

> Subject: xen: fix use of pgd_page now that it really does return a page

applied to tip/x86/urgent, thanks!

	Ingo
