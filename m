Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYDXCV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYDXCV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYDXCVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:21:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbYDXCVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:21:44 -0400
Date: Wed, 23 Apr 2008 19:19:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
In-Reply-To: <480FEC1B.6040102@garzik.org>
Message-ID: <alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org>
 <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org> <20080423000529.GG28933@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org> <480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Apr 2008, Jeff Garzik wrote:
> 
> When drivers make assumptions about system irq numbering, particularly on x86,
> IMO the situation is fragile.

And when people make changes to long-standing and stable infrastructure, 
the situation also gets fragile.

The fact is, stability of interfaces is a really worthy goal in itself. 
Making a change for its own sake is not a good thing. This fixes 
*nothing*, and the driver changes I objected to I objected to because they 
were ugly as sin.

And I want to point out that your patches made it *much* uglier.

So "cleanup" it sure as hell wasn't. That irq number may not be worth all 
that much in itself, but it has no subtle implementation problems (we 
_need_ that irq number for registration and irq handler lookup anyway, so 
it is meaningful from a driver perspective, and is well-defined from a irq 
core standpoint as well).

I don't mind cleanups, but this is "churn". Change for its own sake. If it 
doesn't lead to any _improvement_, it's pointless.

If drivers don't need it, let them ignore it. But let them ignore it in 
ways that work across versions, and in ways that don't cause ridiculous 
and ugly work-arounds for when they do want it (even if it's just for a 
printk() or similar).

		Linus
