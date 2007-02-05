Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXBEUiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXBEUiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXBEUiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:38:24 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43334 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbXBEUiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:38:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Lu, Yinghai" <yinghai.lu@amd.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Luigi Genoni" <luigi.genoni@pirelli.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>
Subject: Re: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during irq migration.
References: <5986589C150B2F49A46483AC44C7BCA4907415@ssvlexmb2.amd.com>
Date: Mon, 05 Feb 2007 13:37:19 -0700
In-Reply-To: <5986589C150B2F49A46483AC44C7BCA4907415@ssvlexmb2.amd.com>
	(Yinghai Lu's message of "Mon, 5 Feb 2007 12:11:19 -0800")
Message-ID: <m1k5ywwdc0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Lu, Yinghai" <yinghai.lu@amd.com> writes:

> From: ebiederm@xmission.com [mailto:ebiederm@xmission.com] 
>>> How about let apic_hangle_pending_vector take the irq too?
>
>>We can't compute the vector by reading the hardware registers after
>>we have acknowledged the irq.
>
>>I hope that was the answer you were looking for I'm not quite certain
>>what you mean by take.
>
> I mean 

I don't see the point.  We would have to miscompute the vector that
we are servicing or improperly fill in vector_irq for that to be useful.

The only corner case I can see that might potentially happen is
"apic_in_service_vector() != irq_vector[irq]" and if that is the case
we don't want to migrate, because the precondition that we are in the
irq handler servicing the expected irq isn't true.

Of course someone would have to set IRQ_MOVE_PENDING pretty fast for
that case to hit, it's a tiny hole probably worth closing though.

Eric

