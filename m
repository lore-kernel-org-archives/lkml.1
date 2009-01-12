Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZALXsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZALXsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZALXsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:48:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54110 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZALXr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:47:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Stefan Assmann <sassmann@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jon Masters <jcm@redhat.com>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>
	<496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com>
Date: Mon, 12 Jan 2009 15:36:29 -0800
In-Reply-To: <200901121151.53195.bjorn.helgaas@hp.com> (Bjorn Helgaas's
	message of "Mon, 12 Jan 2009 11:51:51 -0700")
Message-ID: <m1d4esxfk2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bjorn Helgaas <bjorn.helgaas@hp.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot interrupt equivalent
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't get it. Why are we trying to do such a stupid thing?

This hardware behavior is not specific to boot interrupts or Intel.
This is the classic x86 ioapic behaviour of redirecting a ioapic irq
into a legacy irq when the ioapic entry is disabled.

If you really want not to have problems ensure all irqs 0-15
are disabled, and not needed.  Otherwise you are taking the chance
on something like this happening.

Disabling irqs generically appears to be a crap shoot, and not on a
path hardware vendors look at or care about heavily.  Disabling an irq
in hardware on every interrupt, increasing the cost of the interrupt
and walking down these neglected hardware paths seems stupid.  Especially
when the interrupt line might be shared and we can be disabling several
devices at once.


Is this case really so interesting and compelling that we want to fight
through and figure what we need to do to make this work reliably on every
x86 chipset?

Eric
