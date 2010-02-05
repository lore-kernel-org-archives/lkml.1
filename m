Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0BEKXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 05:23:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:57974 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753147Ab0BEKXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 05:23:30 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/n8kYl/33nOqfDmeCCqCd8vqICDr9AcxNwLbDq6o
	ZNQaZ1CIMPWaos
From: Sven Joachim <svenjoac@gmx.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
References: <1265245849.3362.1.camel@localhost>
	<1265256174.2952.11.camel@localhost>
	<alpine.LFD.2.00.1002032135380.3707@localhost.localdomain>
	<1265272174.2952.20.camel@localhost>
	<20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
	<alpine.LFD.2.00.1002041102530.3707@localhost.localdomain>
	<20100204222522.GF20379@decadent.org.uk>
Date: Fri, 05 Feb 2010 11:23:26 +0100
In-Reply-To: <20100204222522.GF20379@decadent.org.uk> (Ben Hutchings's message
	of "Thu, 4 Feb 2010 22:25:22 +0000")
Message-ID: <87iqachtgh.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-04 23:25 +0100, Ben Hutchings wrote:

> In a Debian initramfs, /init is a script interpreted by /bin/sh.

Yes, I tested without an initramfs though.  The crash happens actually
before init is run.

> I've now tested i386 userland on an x86_64 kernel with all the relevant
> patches on top of 2.6.32.7:
>
> fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack.patch
> split-flush_old_exec-into-two-functions.patch
> sparc-tif_abi_pending-bit-removal.patch
> x86-get-rid-of-the-insane-tif_abi_pending-bit.patch
> fix-flush_old_exec-setup_new_exec-split.patch
> powerpc-tif_abi_pending-bit-removal.patch
>
> This works perfectly, so far as I can see.

It seems so.  The faulty patch is actually the cherry-pick of commit
28f6aeea (net: restore ip source validation), reverting that leads to a
kernel that runs fine.  And this has nothing to do with 64-bit vs
32-bit.

Sven
