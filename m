Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbXHVMgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbXHVMgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761592AbXHVMfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:35:42 -0400
Received: from 1wt.eu ([62.212.114.60]:2238 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762915AbXHVMfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:35:41 -0400
Date: Wed, 22 Aug 2007 14:22:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Gustavo de Nardin <gustavodn@mandriva.com.br>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.17 review 27/58] Include serial_reg.h with userspace headers
Message-ID: <20070822122211.GB10979@1wt.eu>
References: <20070822083844.%N@1wt.eu> <20070822084015.%N@1wt.eu> <20070822092331.GA17947@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822092331.GA17947@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Wed, Aug 22, 2007 at 10:23:32AM +0100, Russell King wrote:
> On Wed, Aug 22, 2007 at 11:39:11AM +0200, Willy Tarreau wrote:
> > As reported by Gustavo de Nardin <gustavodn@mandriva.com.br>, while trying to
> > compile xosview (http://xosview.sourceforge.net/) with upstream kernel
> > headers being used you get the following errors:
> > serialmeter.cc:48:30: error: linux/serial_reg.h: No such file or directory
> > serialmeter.cc: In member function 'virtual void
> > SerialMeter::checkResources()':
> > serialmeter.cc:71: error: 'UART_LSR' was not declared in this scope
> > serialmeter.cc:71: error: 'UART_MSR' was not declared in this scope
> > ..
> 
> It's probably a good thing to repeat what I said privately about this,
> which is:
> 
> | It should be noted that reading the MSR or LSR of an active 8250 UART
> | has side effects.  In the case of MSR, it clears the bits which indicate
> | that the modem status signals have changed, and clears the associated
> | interrupt.  This can result in loss of hardware flow control on the port.
(...)
> | For a tool which presumably is to assist diagnosing serial problems, it
> | would seem to have the capability of causing further additional problems.
> 
> I leave it up to others to decide that keeping backwards compatibility
> with userspace which is quite obviously broken is more important than
> providing userspace with the persuasion to fix their broken code.

While I agree with you that side effects may be undesirable, I still think
it's important to ensure backwards compatibility in -stable branch, for the
following reasons :

  - people who use -stable want to ensure that they can upgrade in order to
    fix security issues or other bugs without risking (much) regression

  - you do not prevent buggy programs from doing wrong things by removing
    headers. What you will end up with is xosview using the quite common
    #ifndef UART_LSR / #define UART_LSR / #endif. In fact, there *may* be
    some legitimate uses of those defines, eventhough this program abuses
    its capabilities.

Eventhough it's not a good practise to rely on kernel headers for userspace,
at least we should limit build regressions on the user side, as it does not
help the end user understand that the program he builds is wrong.

Thanks,
Willy

