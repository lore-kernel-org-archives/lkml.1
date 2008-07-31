Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYGaPLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYGaPLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGaPL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:11:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58536 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYGaPL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:11:28 -0400
Date: Thu, 31 Jul 2008 17:11:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen_alloc_ptpage: cast PFN_PHYS() argument to unsigned
	long
Message-ID: <20080731151115.GB32173@elte.hu>
References: <20080728213209.GF13240@blackpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728213209.GF13240@blackpad>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduardo Habkost <ehabkost@redhat.com> wrote:

> Currently paravirt_ops alloc_p*() uses u32 for the pfn args. We should 
> change that later, but while the pfn parameter is still u32, we need 
> to cast the PFN_PHYS() argument at xen_alloc_ptpage() to unsigned 
> long, otherwise it will lose bits on the shift.
> 
> I think PFN_PHYS() should behave better when fed with smaller 
> integers, but a cast to unsigned long won't be enough for all cases on 
> 32-bit PAE, and a cast to u64 would be overkill for most users of 
> PFN_PHYS().
> 
> We could have two different flavors of PFN_PHYS: one for low pages 
> only (unsigned long) and another that works for any page (u64)), but 
> while we don't have it, we will need the cast to unsigned long on 
> xen_alloc_ptpage().
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/xen - thanks Eduardo.

	Ingo
