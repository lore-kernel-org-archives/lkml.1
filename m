Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXBEUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXBEUAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXBEUAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:00:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54577 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020AbXBEUAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:00:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Lu, Yinghai" <yinghai.lu@amd.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Luigi Genoni" <luigi.genoni@pirelli.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>
Subject: Re: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during irq migration.
References: <5986589C150B2F49A46483AC44C7BCA4907414@ssvlexmb2.amd.com>
Date: Mon, 05 Feb 2007 12:59:18 -0700
In-Reply-To: <5986589C150B2F49A46483AC44C7BCA4907414@ssvlexmb2.amd.com>
	(Yinghai Lu's message of "Mon, 5 Feb 2007 11:29:35 -0800")
Message-ID: <m1r6t4wf3d.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Lu, Yinghai" <yinghai.lu@amd.com> writes:

> Eric,
>
> How about let apic_hangle_pending_vector take the irq too?

We can't compute the vector by reading the hardware registers after
we have acknowledged the irq.

I hope that was the answer you were looking for I'm not quite certain
what you mean by take.

> I wonder if there any chance that you have two IRQ_MOVE_PENDING?

I'm not quite certain what you are asking on the face of it there
is one bit per irq so it is impossible.

I don't think we can get into any trouble we don't let a vector be
reused on a cpu until we know it isn't in irr.  So even if things
come in highly out of order the should still function.

I also have seen irqs migrate on nearly every irq received.

Eric
