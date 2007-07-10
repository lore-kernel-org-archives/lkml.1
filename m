Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbXGJPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbXGJPsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXGJPsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:48:38 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:47704 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbXGJPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:48:37 -0400
Date: Tue, 10 Jul 2007 17:49:35 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Li Yang-r58472 <LeoLi@freescale.com>
Message-ID: <20070710154935.GA3445@enneenne.com>
References: <20070628103619.GW13886@enneenne.com> <989B956029373F45A0B8AF0297081890D834FA@zch01exm26.fsl.freescale.net> <20070628141205.GA13886@enneenne.com> <20070628142949.02ca9eab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628142949.02ca9eab.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] PXA27x UDC driver.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 02:29:49PM -0700, Andrew Morton wrote:
> >
> > +
> > +static int
> > +write_packet(volatile u32 * uddr, struct pxa27x_request *req, unsigned max)
> 
> Please review Documentation/volatile-considered-harmful.txt

The attibute volatile here is necessary in order to avoid getting the
following warnings from the compiler:

     CC      drivers/usb/gadget/pxa27x_udc.o
   drivers/usb/gadget/pxa27x_udc.c: In function `write_ep0_fifo':
   drivers/usb/gadget/pxa27x_udc.c:512: warning: passing arg 1 of `write_packet' discards qualifiers from pointer target type
   drivers/usb/gadget/pxa27x_udc.c: In function `pxa27x_ep_alloc':
   drivers/usb/gadget/pxa27x_udc.c:1206: warning: assignment discards qualifiers from pointer target type
   drivers/usb/gadget/pxa27x_udc.c:1207: warning: assignment discards qualifiers from pointer target type
   drivers/usb/gadget/pxa27x_udc.c:1208: warning: assignment discards qualifiers from pointer target type
   drivers/usb/gadget/pxa27x_udc.c:1209: warning: assignment discards qualifiers from pointer target type
   drivers/usb/gadget/pxa27x_udc.c: At top level:
   drivers/usb/gadget/pxa27x_udc.c:2159: warning: initialization discards qualifiers from pointer target type
   drivers/usb/gadget/pxa27x_udc.c:2160: warning: initialization discards qualifiers from pointer target type

This because the variables reg_* are assigned as:

   .reg_udccsr = &UDCCSR0

where UDCCSR0 are defined as:

   #define UDCCSR0         __REG(0x40600100) /* UDC Control/Status register - Endpoint 0 */

and:

   define __REG(x)	(*((volatile u32 *)io_p2v(x)))

Do you know how I can resolve this?

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
