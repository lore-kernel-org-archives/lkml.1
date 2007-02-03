Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbXBCKXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbXBCKXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXBCKXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:23:40 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46746 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbXBCKXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:23:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<200702031101.22313.ak@suse.de>
Date: Sat, 03 Feb 2007 03:22:33 -0700
In-Reply-To: <200702031101.22313.ak@suse.de> (Andi Kleen's message of "Sat, 3
	Feb 2007 11:01:22 +0100")
Message-ID: <m1wt2z1qxi.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

>> Once the migration operation is complete we know we will receive
>> no more interrupts on this vector so the irq pending state for
>> this irq will no longer be updated.  If the irq is not pending and
>> we are in the intermediate state we immediately free the vector,
>> otherwise in we free the vector in do_IRQ when the pending irq
>> arrives.
>
> Ok for me, although the magic numbers are a little nasty.

You must be talking about (vector/32) *0x10.
The 32 is the number of bits and 0x10 the gap between apic
registers.  I couldn't think of a better form.    If someone
can think of a better way it probably warrants a cleanup patch
at some point.

> What about i386?

i386 does not handle this case but since it is still globally
allocating all of it's vectors and never changes it's vectors during
migration it is totally harmless when an irq comes in on a cpu other
than the one we are expecting it on.

Eric
