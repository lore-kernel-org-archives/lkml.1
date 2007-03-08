Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXCHG40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXCHG40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbXCHG40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:56:26 -0500
Received: from www.osadl.org ([213.239.205.134]:45299 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932622AbXCHG4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:56:25 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Daniel Arai <arai@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45EF6597.5060104@goop.org>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com>	<20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>	<45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org>	<45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>
	 <45EF0CF5.5090305@goop.org>	<45EF175D.6030609@vmware.com>
	 <1173302503.24738.795.camel@localhost.localdomain>
	 <45EF372E.7030600@goop.org>
	 <1173308717.24738.898.camel@localhost.localdomain>
	 <45EF49E9.7040509@vmware.com>
	 <1173313373.24738.937.camel@localhost.localdomain>
	 <45EF6077.9090302@vmware.com>  <45EF6597.5060104@goop.org>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 08:02:32 +0100
Message-Id: <1173337352.24738.951.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 17:23 -0800, Jeremy Fitzhardinge wrote:
> Daniel Arai wrote:
> > But more importantly, we want a kernel that can run both on native hardware and 
> > in a paravirtualized environment.  Linux doesn't really provide abstractions for 
> >   replacing the appropriate code.  We tried to hook into the source code at a 
> > level that seemed possible.
> >   
> 
> Xen doesn't support any kind of apic emulation, so we'll need to hook
> anything which relies on an apic.  The ipi code you quote below will
> probably be one of those.
> 
> My opinion is that pv_ops shouldn't have raw apic operations, but
> instead have appropriate high-level interfaces to achieve the same
> ends.  Zach's counter-argument was basically your's: that the VMI code
> will use a lot of the native code except for the actual apic operations.
> 
> I can live with VMI emulating apics if it wants, so long as it does it
> in private and doesn't make a big scene about it.  We'll need the
> high-level interfaces regardless.

I can't because it reaches out into non private parts of the low level
implementation and is not helping to distangle things and making the
overall code better. No it forces its own view of the world on us
without giving us anything back.

	tglx


