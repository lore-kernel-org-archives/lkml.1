Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXCZMJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXCZMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXCZMJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:09:28 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:4984 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752319AbXCZMJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:09:27 -0400
Date: Mon, 26 Mar 2007 14:09:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Rudolf Marek <r.marek@assembler.cz>
Subject: Re: [PATCH 1/2] MSR: Add support for safe variants
Message-Id: <20070326140911.877430f5.khali@linux-fr.org>
In-Reply-To: <200703261157.l2QBvTJg011821@harpo.it.uu.se>
References: <200703261157.l2QBvTJg011821@harpo.it.uu.se>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael,

On Mon, 26 Mar 2007 13:57:29 +0200 (MEST), Mikael Pettersson wrote:
> On Mon, 26 Mar 2007 13:29:37 +0200, Jean Delvare wrote:
> > * * * * * Updated patch * * * * *
> > 
> > From: Rudolf Marek <r.marek@assembler.cz>
> > 
> > Add safe (exception handled) variants of rdmsr_on_cpu and wrmsr_on_cpu.
> > You should use these when the target MSR may not actually exist, as
> > doing so could trigger an exception which the regular functions do not
> > handle. The safe variants are slower, though.
> > 
> > The upcoming coretemp hardware monitoring driver will need this.
> 
> Maybe I'm in the minority here, but I for one strongly believe
> that any attempt to access an MSR "which might not be there" is
> inherently wrong. It implies that your HW detection is incomplete,
> which in combination with MSR accesses means that you may end up
> accessing MSRs that aren't at all what you think they should be.

Hopefully CPU manufacturers are not that stupid and don't implement
MSRs using the same number and doing different things in CPU models
which are otherwise similar enough for one driver to attempt to handle
them both. But of course it's probably only a matter of time before I am
proven wrong...

I agree with you that accessing an MSR which might not be there should
be avoided where possible and only used as a last resort. But until
technical documentation is perfectly correct for all CPUs out there,
there will always be cases where we need to do that.

> Who supplies these imprecise MSR definitions anyway?
> Intel manuals? ACPI?

Intel. Rudolf will know the details better.

-- 
Jean Delvare
