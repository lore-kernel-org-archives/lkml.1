Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbZFNMPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbZFNMPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbZFNMPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:15:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36650 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbZFNMPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:15:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>, "Benjamin S." <sbenni@gmx.de>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Date: Sun, 14 Jun 2009 14:15:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, js@sig21.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141400.27331.rjw@sisk.pl> <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141415.16949.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Thomas Gleixner wrote:
> On Sun, 14 Jun 2009, Rafael J. Wysocki wrote:
> > Evidently, the change of the interrupt handling during suspend-resume,
> > commit 2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7 (PM: Rework handling of
> > interrupts during suspend-resume) broke resume (specifically, the enabling of
> > nonboot CPUs) on the Benjamin's machine, but only if MSI support is enabled.
> > Also, resume works if suspend_device_irqs() and resume_device_irqs() in
> > drivers/base/power/main.c are commented out.
> > 
> > Is there anything the MSI code does in __enable_irq() and/or __disable_irq()
> > that might cause this problem to appear?
> 
> Not that I'm aware of. Which of the devices is using MSI ? Have to
> tried to skip only the MSI ones in suspend/resume_device_irqs() ?

Good idea.

Benjamin, please send /proc/interrupts from your system.

Best,
Rafael
