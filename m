Return-Path: <linux-kernel-owner+w=401wt.eu-S933687AbXBYJIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbXBYJIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 04:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933688AbXBYJIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 04:08:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50582 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687AbXBYJIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 04:08:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MSI entry unlinked before arch_teardown_msi_irq().
References: <20070224.235020.92583817.davem@davemloft.net>
Date: Sun, 25 Feb 2007 02:08:07 -0700
In-Reply-To: <20070224.235020.92583817.davem@davemloft.net> (David Miller's
	message of "Sat, 24 Feb 2007 23:50:20 -0800 (PST)")
Message-ID: <m17iu6r4eg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> ric, you recommended to me that I use:
>
> 	struct msi_desc *entry = get_irq_data(irq);
>
> in my arch_teardown_msi_irq() routine earlier, but the current
> code unlinks the entry before the call to arch_teardown_msi_irq()
> so I get OOPS's on shutdown on sparc64 because of this since
> get_irq_data() will return NULL at that point.
>
> Can you fix this up or suggest how I should code the patch to
> your liking so I can take care of it?

I'm guessing my patch to switch the appropriate from get_irq_data to
get_irq_msi was merged in between that conversation and this.

Sorry about that. 

There was a real problem that ppc used the data stored in get_irq_data
for something else.  So we added a dedicated pointer to struct irq_desc.

If that isn't the issue holler and I will look into it a little more.

Eric
