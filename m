Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813Ab0ANJh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0ANJh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957Ab0ANJh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:37:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33774 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0ANJh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:37:28 -0500
Date: Thu, 14 Jan 2010 09:33:22 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, arnd@arndb.de, geert@linux-m68k.org,
       acme@redhat.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: sys_recvmmsg: wire up or not?
Message-ID: <20100114093322.GA3484@flint.arm.linux.org.uk>
Mail-Followup-To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Miller <davem@davemloft.net>, arnd@arndb.de,
	geert@linux-m68k.org, acme@redhat.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
References: <10f740e80912260239n17bbbd08w6c3065c12bde9c95@mail.gmail.com> <200912261212.14264.arnd@arndb.de> <1263442833.724.325.camel@pasglop> <20100113.202807.233259060.davem@davemloft.net> <1263452379.724.348.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263452379.724.348.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 05:59:39PM +1100, Benjamin Herrenschmidt wrote:
> Oh I definitely agree that a direct syscall is better, and I wonder in
> fact if I should add new syscalls in addition to socketcall for powerpc,
> for glibc to do a slow migration :-) I was just wondering about the
> inconsistency for archs like us who have socketcall today, to also have
> to define the syscall ...

On ARM, we used to use socketcall exclusively.  We've since added all
the direct socket and IPC calls to our syscall table as part of the
big EABI shakeup.  They certainly get used on EABI, whereas OABI has
a choice.

They were made available in two stages - first the numbers were reserved
and the calls were added to the call table.  A few years later, we
exposed the syscall numbers in unistd.h.

It's now been almost 4 years since this was done, and there have been
no bug reports.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
