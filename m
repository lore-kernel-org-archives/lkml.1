Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZF3Msx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZF3Msx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZF3Msr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:48:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZF3Msq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:48:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [Bug #13644] hibernation/swsusp lockup due to acpi-cpufreq
Date: Tue, 30 Jun 2009 14:48:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.RZF.MjASKB@chimera> <20090630004041.GA11641@sig21.net>
In-Reply-To: <20090630004041.GA11641@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301448.55209.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009, Johannes Stezenbach wrote:
> On Mon, Jun 29, 2009 at 02:31:01AM +0200, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13644
> > Subject		: hibernation/swsusp lockup due to acpi-cpufreq
> > Submitter	: Johannes Stezenbach <js@sig21.net>
> > Date		: 2009-06-16 01:27 (13 days old)
> > References	: http://lkml.org/lkml/2009/6/15/630
> > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I tested v2.6.31-rc1-228-g2bfdd79 and the bug is still there.
> It actually got worse, the local_irq_save/restore workaround
> in kernel/up-c (http://lkml.org/lkml/2009/6/16/333) doesn't fix it
> anymore, it hangs at suspend before writing out the image.
> 
> With the up.c workaround (including a
> WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);)
> applied and no_console_suspend I captured the attached
> output using a crappy webcam.  (Without the workaround
> there is a huge spew of warnings about irqs enabled
> unexpectedly.)  I guess the interesting part is
> 
>   pm_op(): pci_pm_thaw returns -16
>   PM: Device 0000:00:00.0 failed to thaw: error -16

Hmm, it looks like we fail to thaw the host bridge.

> (PCI info is in http://lkml.org/lkml/2009/6/15/630)

Well, thanks for the update.  I'll do my best to fix the cpufreq suspend
before 2.6.31 final.

Best,
Rafael
