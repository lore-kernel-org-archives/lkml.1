Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbXINVWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbXINVWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbXINVWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:22:44 -0400
Received: from gw.goop.org ([64.81.55.164]:43777 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbXINVWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:22:43 -0400
Message-ID: <46EAFBA0.4020503@goop.org>
Date: Fri, 14 Sep 2007 14:22:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com> <46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws>
In-Reply-To: <46EAF6FC.80207@codemonkey.ws>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> The whole point of using the instruction is to allow hypercalls to be
> used in many locations.  This has the nice side effect of not
> requiring a central hypercall initialization routine in the guest to
> fetch the hypercall page.  A PV driver can be completely independent
> of any other code provided that it restricts itself to it's hypercall
> namespace.

I see.  So you take the fault, disassemble the instruction, see that its
another CPU's vmcall instruction, and then replace it with the current
CPU's vmcall?

> Xen is currently using 0/1/2.  I had thought it was only using 0/1. 
> The intention was not to squash Xen's current CPUID usage so that it
> would still be possible for Xen to make use of the guest code.  Can we
> agree that Xen won't squash leaves 3/4 or is it not worth trying to be
> compatible at this point?

No, the point is that you're supposed to work out which hypervisor it is
from the signature in leaf 0, and then the hypervisor can put anything
it wants in the other leaves.

    J
