Return-Path: <linux-kernel-owner+w=401wt.eu-S936284AbXJSTgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936284AbXJSTgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763120AbXJSTgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:36:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36879 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbXJSTgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:36:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
References: <20071019075443.GA6407@havoc.gtf.org>
	<alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain>
	<m1bqavgdbf.fsf@ebiederm.dsl.xmission.com>
	<20071019190721.GA1514@elte.hu>
Date: Fri, 19 Oct 2007 13:35:55 -0600
In-Reply-To: <20071019190721.GA1514@elte.hu> (Ingo Molnar's message of "Fri,
	19 Oct 2007 21:07:22 +0200")
Message-ID: <m1wstigan8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> > thanks for doing this.
>> 
>> Yes.  keeping this alive is good.
>> 
>> The practical question is how do we make this change without breaking 
>> the drivers that use their irq argument.
>
> the get_irq_regs() approach worked out really well. We should do a 
> get_irq_nr() and be done with it?

The problem are some drivers today pass in 0 for their irq number
to flag that they are calling the interrupt handler in a polling
mode (not from interrupt context?) so the same logic doesn't quite apply.

Do what you suggest would likely break those drivers.

Eric
