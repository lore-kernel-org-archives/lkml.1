Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbYDKPTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbYDKPTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760469AbYDKPTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:19:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760276AbYDKPTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:19:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on free_irq
Date: Fri, 11 Apr 2008 17:19:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com> <1207899030.15605.1.camel@x61.ebiederm.org> <alpine.LFD.1.10.0804111217450.3261@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804111217450.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804111719.44833.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of April 2008, Thomas Gleixner wrote:
> On Fri, 11 Apr 2008, Eric W. Biederman wrote:
> > On Fri, 2008-04-11 at 00:17 -0700, Yinghai Lu wrote:
> > > On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > > On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > >  > On Thu, 10 Apr 2008, Yinghai Lu wrote:
> > > >  >  > last week found:
> > > >  >  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
> > > >  >  > forcedeth doesn't work anymore.
> > > >  >  >
> > > >  >  > I stared at forcedeth.c two days. and revert every patches about that
> > > >  >  > doesn't help.
> > > >  >
> > > >  >  So forcedeth does not come up again, when you kexec from linus.git
> > > >  >  into an older distro kernel. Or is it the other way round ?
> > > >  RHEL 5.1 kexec RHEL 5.1 : works
> > > >  RHEL 5.1 kexec linus kernel: works
> > > >  linus (after -rc2) kexec linus tree: works:
> > > >  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
> > > >  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
> > > >
> > > the forcedeth can not get IP address...
> > 
> > Sounds like you are not getting any interrupts when you receive a
> > packet.  (i.e. The interrupt line is staying disabled).
> > 
> > Is MSI an option here?  I'm wondering if we disable the MSI and
> > something is not enabling it.
> 
> Hmm, we disable the interrupt on free_irq(), but we reenable it in
> request_irq()/setup_irq(), which is called when the forcedeth driver
> initializes in the kexeced kernel. So there is some other deeper down
> problem lurking.
> 
> Yinghai, can you apply that patch to RHEL 5.1 and check, what happens
> if you do:
> 
> modprobe forcedeth
> ifup ...
> ifdown ...
> rmmod forcedeth
> modprobe forcedeth
> ifup ...
> 
> This should result in the same problem, but probably simpler to debug.

I've just got a report from a forcedeth user that it doesn't work after a
resume from RAM for him any more.  Can it be related?

Rafael
