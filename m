Return-Path: <linux-kernel-owner+w=401wt.eu-S1762181AbXKNAsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762181AbXKNAsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbXKNAsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:48:01 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47947 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757483AbXKNAsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:48:00 -0500
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
From: Zachary Amsden <zach@vmware.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Tobias Powalowski <t.powa@gmx.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20071113222212.GA1322@infradead.org>
References: <200711131139.42791.t.powa@gmx.de> <473A073C.2020201@goop.org>
	 <20071113222212.GA1322@infradead.org>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 16:51:04 -0800
Message-Id: <1195001464.6352.109.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-13 at 22:22 +0000, Christoph Hellwig wrote:
> On Tue, Nov 13, 2007 at 12:21:16PM -0800, Jeremy Fitzhardinge wrote:
> > Subject: x86/paravirt: revert exports to restore old behaviour
> > 
> > Subdividing the paravirt_ops structure caused a regression in certain
> > non-GPL modules which try to use mmu_ops and cpu_ops.  This restores
> > the old behaviour, and makes it consistent with the
> > non-CONFIG_PARAVIRT case.
> 
> NACK, both of these are internal and graphics drivers should not be
> using them.

Some of them are internal, but some are not, they just happened to be
privileged CPU operations available to anyone.

Does anyone know what hooks they are actually using?  Something like
reading MSRs is not internal at all, it is CPU specific, and the
graphics drivers might have very good reasons to read them to figure out
how AGP is configured for example.

The graphics drivers most certainly don't need to be paravirtualized
however, so they could always work around this with raw asm constructs.

The mmu_ops hook is more debatable.  But until someone figures out what
hooks they want, we can't know whether they are internal or not.  In any
case, this is a regression.

Zach

