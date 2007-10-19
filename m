Return-Path: <linux-kernel-owner+w=401wt.eu-S935866AbXJSTiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935866AbXJSTiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXJSTir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:38:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57045 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbXJSTiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:38:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] irq-remove: arch non-trivial
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075543.GC6407@havoc.gtf.org>
	<m1tzonghco.fsf@ebiederm.dsl.xmission.com>
	<4718E67F.6000300@garzik.org>
Date: Fri, 19 Oct 2007 13:38:39 -0600
In-Reply-To: <4718E67F.6000300@garzik.org> (Jeff Garzik's message of "Fri, 19
	Oct 2007 13:16:47 -0400")
Message-ID: <m1przagaio.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Eric W. Biederman wrote:
>> In this case we can easily pass the irqno into request_irq, allowing
>> us to do "unsigned int intno = (unsigned int)dev_id;".
>>
>> I suspect this is the case for the majority of the non-trivial users
>> as well.
>
>
> Not that easy, alas :)  Save for weirdos like the mac drivers I highlighted, it
> seems like most drivers in the non-trivial already pass a useful pointer to
> request_irq().

I was talking about vm86_32.c in particular.  Where we allow user space
through the vm86 interface to directly handle the isa irq.

> But as I mentioned, most of the "non-trivial" uses are actually trivial -- just
> not as simple as removing the 'int irq' argument.  Most of the time the irq
> number is used in non-critical ways like printk's.  A few times its used to
> index into a structure (something dev_id could replace).

Yes.

Eric
