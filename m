Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYDKHat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYDKHat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYDKHal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:30:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56571 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbYDKHak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:30:40 -0400
Subject: Re: regression caused by: genirq: do not leave interupts enabled
	on free_irq
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	 <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
	 <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
	 <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 00:30:30 -0700
Message-Id: <1207899030.15605.1.camel@x61.ebiederm.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on mgr1.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-11 at 00:17 -0700, Yinghai Lu wrote:
> On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >  > On Thu, 10 Apr 2008, Yinghai Lu wrote:
> >  >  > last week found:
> >  >  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
> >  >  > forcedeth doesn't work anymore.
> >  >  >
> >  >  > I stared at forcedeth.c two days. and revert every patches about that
> >  >  > doesn't help.
> >  >
> >  >  So forcedeth does not come up again, when you kexec from linus.git
> >  >  into an older distro kernel. Or is it the other way round ?
> >  RHEL 5.1 kexec RHEL 5.1 : works
> >  RHEL 5.1 kexec linus kernel: works
> >  linus (after -rc2) kexec linus tree: works:
> >  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
> >  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
> >
> the forcedeth can not get IP address...

Sounds like you are not getting any interrupts when you receive a
packet.  (i.e. The interrupt line is staying disabled).

Is MSI an option here?  I'm wondering if we disable the MSI and
something is not enabling it.

Eric


