Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZFNMAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZFNMAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbZFNMAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:00:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZFNMAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:00:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Benjamin S." <sbenni@gmx.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Date: Sun, 14 Jun 2009 14:00:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, js@sig21.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <matthew@wil.cx>
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141319.40536.rjw@sisk.pl> <20090614134851.637daf37@pluto-lenny.milky.way>
In-Reply-To: <20090614134851.637daf37@pluto-lenny.milky.way>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141400.27331.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Benjamin S. wrote:
> On Sun, 14 Jun 2009 13:19:40 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday 14 June 2009, Benjamin S. wrote:
> > > 
> > > On Sun, 14 Jun 2009 12:35:24 +0200
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > Thanks for the report, the problem seems to be related to the chipset, because
> > > > I'm unable to reproduce it with SB600 and a fairly new AMD CPU.
> > > > 
> > > > Does the resume work if you comment out suspend_device_irqs() and
> > > > resume_device_irqs() in drivers/base/power/main.c ?
> > > 
> > > Yes, 2.6.30 without the two lines resumes without problems.\
> > 
> > Does it help (with the two lines present again) if the kernel is compiled with
> > CONFIG_PCI_MSI unset?
> 
> Yes, it works.

OK, we need some help.

Ingo,

Evidently, the change of the interrupt handling during suspend-resume,
commit 2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7 (PM: Rework handling of
interrupts during suspend-resume) broke resume (specifically, the enabling of
nonboot CPUs) on the Benjamin's machine, but only if MSI support is enabled.
Also, resume works if suspend_device_irqs() and resume_device_irqs() in
drivers/base/power/main.c are commented out.

Is there anything the MSI code does in __enable_irq() and/or __disable_irq()
that might cause this problem to appear?

Best,
Rafael
