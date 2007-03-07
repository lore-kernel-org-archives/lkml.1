Return-Path: <linux-kernel-owner+w=401wt.eu-S2992577AbXCGVIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992577AbXCGVIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992573AbXCGVIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:08:47 -0500
Received: from www.osadl.org ([213.239.205.134]:33453 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423006AbXCGVIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:08:42 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Dan Hecht <dhecht@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45EF2560.7090104@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>
	 <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com>
	 <45EF1C80.50900@goop.org>  <45EF2560.7090104@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 22:14:47 +0100
Message-Id: <1173302087.24738.785.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 12:49 -0800, Dan Hecht wrote:
> On 03/07/2007 12:11 PM, Jeremy Fitzhardinge wrote:
> > Dan Hecht wrote:
> >> Jeremy, I saw you sent out the Xen version earlier, thanks.  Here's
> >> ours for reference (please excuse any formating issues); it's also
> >> lean. We'll send out a proper patch later after some more testing:
> > 
> > So the interrupt side of the clockevent comes through the virtual apic? 
> > Where does evt->handle_event get called?
> > 
> 
> Yeah, we use the same interrupt handlers as normal i386: timer_interrupt 
> and smp_apic_timer_interrupt.  That way we don't need to duplicate the 
> interrupt handler code.

Oh well. Here we are again. 2 hypervisors - 4 different views on how to
inject events into the kernel.

This is the complete wrong approach. Paravirtualization should not abuse
existing hardware drivers. It should just provide their own sane
abstract implementation.

Please stop this _NOW_

	tglx


