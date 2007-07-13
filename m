Return-Path: <linux-kernel-owner+w=401wt.eu-S1761854AbXGMAxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854AbXGMAxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXGMAxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:53:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33209 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXGMAxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:53:38 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 12 Jul 2007 20:51:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, matthew@wil.cx
Subject: Re: [PATCH] Make asm-generic/ioctl.h more generic using conditionals.
In-Reply-To: <20070712161146.78e078b5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707122044400.12963@localhost.localdomain>
References: <Pine.LNX.4.64.0707100629070.11966@localhost.localdomain>
 <20070712161146.78e078b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Jul 2007, Andrew Morton wrote:

> On Tue, 10 Jul 2007 06:33:26 -0400 (EDT)
> "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> >
> > Allow individual architectures to override a small set of macros
> > before including asm-generic/ioctl.h, in order to greatly simplify a
> > number of existing ioctl.h files.
> >
> > The overrideable macros would be:
> >
> > 	_IOC_SIZEBITS
> > 	_IOC_DIRBITS
> > 	_IOC_NONE
> > 	_IOC_WRITE
> > 	_IOC_READ
> >
> > ---
> >
> >   i've submitted this once before, and it didn't seem to garner a
> > lot of attention one way or the other.  this patch can be applied
> > standalone and shouldn't affect anything, but it would
> > subsequently allow at least a few ioctl.h files to be shortened
> > considerably.
>
> It would be good if we could see one of these followon patches.  If
> such an example patch (cc'ed to the arch maintainer, please) looks
> OK then we can go ahead with this base patch.

as a trivial example, i can demonstrate on include/asm-mips/ioctl.h.
once the generic ioctl.h file is enhanced, then the entire mips
ioctl.h file is reduced from 94 lines to:

===================================
#define _IOC_SIZEBITS	13
#define _IOC_DIRBITS	3

#define _IOC_NONE	1U
#define _IOC_READ	2U
#define _IOC_WRITE	4U

#include <asm-generic/ioctl.h>

/*
 * The following are included for compatibility
 */

#define _IOC_VOID	0x20000000
#define _IOC_OUT	0x40000000
#define _IOC_IN		0x80000000
#define _IOC_INOUT	(IOC_IN|IOC_OUT)
=================================

and the last part of that is purely MIPS-specific content.

  there are at least a couple other ioctl.h files that could be
reduced even further.  asm-parisc/ioctl.h would subsequently become
all of four lines:

=================================
#define _IOC_NONE	0U   (this line isn't even necessary)
#define _IOC_WRITE	2U
#define _IOC_READ	1U

#include <asm-generic/ioctl.h>
=================================

etc, etc.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
