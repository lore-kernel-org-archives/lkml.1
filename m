Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbXD0Wnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbXD0Wnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbXD0Wnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:43:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383AbXD0Wne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:43:34 -0400
Date: Fri, 27 Apr 2007 15:41:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Hafting <helgehaf@aitel.hist.no>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang - bisection result
Message-Id: <20070427154156.c1388f94.akpm@linux-foundation.org>
In-Reply-To: <20070427210458.GA4302@aitel.hist.no>
References: <20070411194227.GA31286@aitel.hist.no>
	<20070411134346.d10765da.akpm@linux-foundation.org>
	<20070411230700.GA4023@aitel.hist.no>
	<Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz>
	<20070412202519.GB14705@aitel.hist.no>
	<Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz>
	<462F2558.5010909@aitel.hist.no>
	<Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
	<46312787.1020702@aitel.hist.no>
	<Pine.LNX.4.64.0704270038150.20657@twin.jikos.cz>
	<20070427210458.GA4302@aitel.hist.no>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 23:04:58 +0200
Helge Hafting <helgehaf@aitel.hist.no> wrote:

> On Fri, Apr 27, 2007 at 12:39:19AM +0200, Jiri Kosina wrote:
> > On Fri, 27 Apr 2007, Helge Hafting wrote:
> > 
> > > 2.6.21-rc6 boots up fine.  Both rc6 and rc7 has a different problem - 
> > > the machine tends to hang after some minutes work in X.  That hang is 
> > > unusual in that moving the mouse still move the X cursor, but everything 
> > > else stops and sysrq fails me. But that is another story.
> > [...]
> > > The (first) "hanging" patch in 2.6.21-rc6-mm1 is: git-acpi.patch
> > 
> > Hi Helge,
> > 
> > thanks for the effort. If you take stock rc6-mm1 and revert just 
> > git-acpi.patch, doesn the machine behave correctly?
> 
> Just compiled & booted such a kernel - it came up fine!
> So it looks like USB is fine then, and the problem is in
> that ACPI patch.
> 

OK, thanks.  Len&co: we've established that 2.6.21-rc6-mm1's git-acpi.patch
causes this:

> 2.6.21-rc6 boots up fine.  Both rc6 and rc7 has a different problem - the
> machine tends to hang after some minutes work in X.  That hang is
> unusual in that moving the mouse still move the X cursor, but
> everything else stops and sysrq fails me. But that is another story.
> 
> rc6 boots, rc6-mm1 hangs at the "usbcore registered hiddev" message.
> Bisection:
> 1, 2, 3: the three first hangs at "usbcore registered hiddev"
> 4, 5, 6: the next three hangs at a message about ACPI  PCI[A]->IRQ17
> I decided to keep bisecting these hangers as "bad", I don't really know
> if this could be the same thing or completely different issues.  If they are
> different, then one problem will mask the other anyway, so
> calling every hanging kernel "bad" will at least find the first broken 
> patch.
> 7: boots up ok!
> 8,9,10: hangs at the aboce mentioned ACPI message
> The (first) "hanging" patch in 2.6.21-rc6-mm1 is: git-acpi.patch
> 
> 
