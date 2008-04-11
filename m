Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbYDKQGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbYDKQGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbYDKQGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:06:24 -0400
Received: from iabervon.org ([66.92.72.58]:48363 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760120AbYDKQGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:06:23 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2008 12:06:23 EDT
Date: Fri, 11 Apr 2008 11:59:40 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on
 free_irq
In-Reply-To: <86802c440804110140i7752e0ayadca550cdddfd599@mail.gmail.com>
Message-ID: <alpine.LNX.1.00.0804111145020.19665@iabervon.org>
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>  <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>  <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>  <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
  <1207899030.15605.1.camel@x61.ebiederm.org> <86802c440804110140i7752e0ayadca550cdddfd599@mail.gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Yinghai Lu wrote:

> On Fri, Apr 11, 2008 at 12:30 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> >
> >
> >  On Fri, 2008-04-11 at 00:17 -0700, Yinghai Lu wrote:
> >  > On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >  > >  RHEL 5.1 kexec RHEL 5.1 : works
> >  > >  RHEL 5.1 kexec linus kernel: works
> >  > >  linus (after -rc2) kexec linus tree: works:
> >  > >  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
> >  > >  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
> >  > >
> >  > the forcedeth can not get IP address...
> >
> >  Sounds like you are not getting any interrupts when you receive a
> >  packet.  (i.e. The interrupt line is staying disabled).
> >
> >  Is MSI an option here?  I'm wondering if we disable the MSI and
> >  something is not enabling it.
> 
> mcp55 is using msi for forcedeth
> 
> MSI.. will look at the driver in RHEL 5.1
> 
> it seems that another server with ck804 works because it is using ioapic.

When turning on MSI for forcedeth, we do the INTx disable thing (and it's 
actually necessary for at least some forcedeth-driven hardware); if we're 
not disabling MSI (and making INTx undisabled), the old kernel may not 
undisable INTx but expect to have legacy interrupts delivered.

	-Daniel
*This .sig left intentionally blank*
