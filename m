Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbXEQRSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbXEQRSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbXEQRSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:18:13 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:42146 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbXEQRSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:18:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch] early printk and boot console fixups.
Date: Thu, 17 May 2007 11:18:09 -0600
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Gerd Hoffmann <kraxel@suse.de>,
       Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <45D5C473.4010608@suse.de> <200705161214.16426.bjorn.helgaas@hp.com> <Pine.LNX.4.64N.0705171038050.11098@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0705171038050.11098@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171118.09413.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007 03:45:36 am Maciej W. Rozycki wrote:
> On Wed, 16 May 2007, Bjorn Helgaas wrote:
> > >  Given the generic name of "uart" I am assuming this will work with any 
> > > UART driver making use of the serial_core.c core -- am I correct?
> > 
> > I knew somebody would ask that eventually :-)
> > 
> > Unfortunately, the answer is "no."  "console=uart" only works with
> > 8250-compatible devices.
> 
>  But is it a design limitation or is it just that other UART drivers have 
> to be modified to work with this option?  My point is if the former, then 
> the option should be something like "console=8250" (the right-hand side 
> being the name of the driver involved; others may want to add support for 
> other drivers).  If the latter, then it's fine as is as other UART drivers 
> may be wired to this code as a need arises.

"console=8250" probably would have been a better choice.  I think
this could be changed without too much hassle.

It might be possible to extend "console=uart" so one could do
"console=uart,io,0x3f8,9600n8,21285" (where "21285" is a non-8250
UART type).  But that seems ugly to me.  I'd rather have
"console=21285", "console=68328", etc.

I just want the "console=<tag>" to explicitly identify the UART
type so we don't have to poke at the thing and guess what it is.

Bjorn
