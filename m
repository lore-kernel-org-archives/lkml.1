Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbZFNMJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbZFNMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZFNMJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:09:48 -0400
Received: from www.tglx.de ([62.245.132.106]:55669 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbZFNMJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:09:48 -0400
Date: Sun, 14 Jun 2009 14:09:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Benjamin S." <sbenni@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, js@sig21.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
In-Reply-To: <200906141400.27331.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141319.40536.rjw@sisk.pl> <20090614134851.637daf37@pluto-lenny.milky.way> <200906141400.27331.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Rafael J. Wysocki wrote:
> Evidently, the change of the interrupt handling during suspend-resume,
> commit 2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7 (PM: Rework handling of
> interrupts during suspend-resume) broke resume (specifically, the enabling of
> nonboot CPUs) on the Benjamin's machine, but only if MSI support is enabled.
> Also, resume works if suspend_device_irqs() and resume_device_irqs() in
> drivers/base/power/main.c are commented out.
> 
> Is there anything the MSI code does in __enable_irq() and/or __disable_irq()
> that might cause this problem to appear?

Not that I'm aware of. Which of the devices is using MSI ? Have to
tried to skip only the MSI ones in suspend/resume_device_irqs() ?

Thanks,

	tglx
