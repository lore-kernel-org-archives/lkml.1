Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbXINUxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbXINUxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXINUxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:53:30 -0400
Received: from gw.goop.org ([64.81.55.164]:55401 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbXINUx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:53:29 -0400
Message-ID: <46EAF4C6.8090903@goop.org>
Date: Fri, 14 Sep 2007 13:53:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       Ingo Molnar <mingo@elte.hu>, Dor Laor <dor.laor@qumranet.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11897991353793-git-send-email-aliguori@us.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> This patch refactors the current hypercall infrastructure to better support live
> migration and SMP.  It eliminates the hypercall page by trapping the UD
> exception that would occur if you used the wrong hypercall instruction for the
> underlying architecture and replacing it with the right one lazily.
>   

I guess it would be pretty rude/unlikely for these opcodes to get reused
in other implementations...  But couldn't you make the page trap
instead, rather than relying on an instruction fault?

> It also introduces the infrastructure to probe for hypercall available via
> CPUID leaves 0x40000002.  CPUID leaf 0x40000003 should be filled out by
> userspace.
>   

Is this compatible with Xen's (and other's) use of cpuid?  That is,
0x40000000 returns a hypervisor-specific signature in e[bcd]x, and eax
has the max hypervisor leaf.

    J
