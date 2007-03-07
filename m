Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbXCGUvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbXCGUvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932813AbXCGUvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:51:37 -0500
Received: from www.osadl.org ([213.239.205.134]:49669 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932774AbXCGUvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:51:36 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, James Morris <jmorris@namei.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45EF1C80.50900@goop.org>
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
	 <45EF1C80.50900@goop.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 21:57:44 +0100
Message-Id: <1173301065.24738.766.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 12:11 -0800, Jeremy Fitzhardinge wrote:
> Dan Hecht wrote:
> > Jeremy, I saw you sent out the Xen version earlier, thanks.  Here's
> > ours for reference (please excuse any formating issues); it's also
> > lean. We'll send out a proper patch later after some more testing:
> 
> So the interrupt side of the clockevent comes through the virtual apic? 
> Where does evt->handle_event get called?


>         /* We use normal irq0 handler on cpu0. */
>         time_init_hook();

That's exactly the thing I ranted about before. We keep the historic
view of emulated hardware and just wrap it into enough glue code instead
of doing an abstract design, which just gets rid of those hardware
assumptions at all. That's the big advantage of paravirtualization, but
the current way on paravirt ops is just ignoring this.

	tglx


