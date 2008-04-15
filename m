Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYDOHos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYDOHos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYDOHok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:44:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbYDOHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:44:39 -0400
Date: Tue, 15 Apr 2008 00:44:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Jeff Garzik" <jeff@garzik.org>, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on
 free_irq
Message-Id: <20080415004400.bb941191.akpm@linux-foundation.org>
In-Reply-To: <86802c440804111248je6dfa99va8eec42531f4b689@mail.gmail.com>
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	<alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
	<86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
	<86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
	<1207899030.15605.1.camel@x61.ebiederm.org>
	<86802c440804111122x5c106779g60f1c04ae21fed94@mail.gmail.com>
	<86802c440804111248je6dfa99va8eec42531f4b689@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 12:48:43 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Fri, Apr 11, 2008 at 11:22 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Fri, Apr 11, 2008 at 12:30 AM, Eric W. Biederman
> >  <ebiederm@xmission.com> wrote:
> >  >
> >  >
> >
> >
> > >  On Fri, 2008-04-11 at 00:17 -0700, Yinghai Lu wrote:
> >  >  > On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >  >  > > On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >  >  > >  > On Thu, 10 Apr 2008, Yinghai Lu wrote:
> >  >  > >  >  > last week found:
> >  >  > >  >  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
> >  >  > >  >  > forcedeth doesn't work anymore.
> >  >  > >  >  >
> >  >  > >  >  > I stared at forcedeth.c two days. and revert every patches about that
> >  >  > >  >  > doesn't help.
> >  >  > >  >
> >  >  > >  >  So forcedeth does not come up again, when you kexec from linus.git
> >  >  > >  >  into an older distro kernel. Or is it the other way round ?
> >  >  > >  RHEL 5.1 kexec RHEL 5.1 : works
> >  >  > >  RHEL 5.1 kexec linus kernel: works
> >  >  > >  linus (after -rc2) kexec linus tree: works:
> >  >  > >  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
> >  >  > >  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
> >  >  > >
> >  >  > the forcedeth can not get IP address...
> >  >
> >  >  Sounds like you are not getting any interrupts when you receive a
> >  >  packet.  (i.e. The interrupt line is staying disabled).
> >  >
> >  >  Is MSI an option here?  I'm wondering if we disable the MSI and
> >  >  something is not enabling it.
> >
> >
> >
> >  after
> >  setpci -s 0x00:08.0 0x60.b=0xfe
> >
> >  the eth0 can get ip address with ifup eth0.
> 
> it is RHEL 5.1 problem...with msi.
> 
> somehow msi entry msi_attrib_maskbit=is_mask_bit_support always get
> 0...., and use msi_irq_wo_maskbit_type instead of
> msi_irq_w_maskbit_type
> 
> so when load that directly without kexec
> that 0x60 always to 0x00.
> 
> and this time kernel after 2.6.25-rc2 ( not included) really shutdown
> the msi with 0xff the all maskbit...
> 

So... where did this end up?   It's a post-2.6.24 regression, isn't it?

Do we think it's a bug in the RHEL 5.1 kernel?  Even so, that's a problem
for the 2.6.25 kernel.

