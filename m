Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbZANWsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbZANWsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbZANWsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:48:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43925 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbZANWsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:48:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jon Masters <jcm@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Stefan Assmann <sassmann@suse.de>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>
	<496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com>
	<m1d4esxfk2.fsf@frodo.ebiederm.org>
	<1231806563.4094.25.camel@perihelion.bos.jonmasters.org>
	<20090113014723.GA11366@elte.hu> <m1prirx3xn.fsf@frodo.ebiederm.org>
	<1231820798.4094.34.camel@perihelion.bos.jonmasters.org>
	<20090114114006.GF8625@elte.hu>
	<1231960709.23174.0.camel@londonpacket.bos.redhat.com>
Date: Wed, 14 Jan 2009 14:42:47 -0800
In-Reply-To: <1231960709.23174.0.camel@londonpacket.bos.redhat.com> (Jon
	Masters's message of "Wed, 14 Jan 2009 14:18:29 -0500")
Message-ID: <m11vv5wlug.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jon Masters <jcm@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot interrupt equivalent
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters <jcm@redhat.com> writes:

> On Wed, 2009-01-14 at 12:40 +0100, Ingo Molnar wrote:
>
>> it's not just -rt, but it is also needed for the concept of threaded IRQ 
>> handlers - which was discussed at the Kernel Summit to be desired for 
>> mainline.
>
> Right. I'm poking at Thomas' patches and hope to post something soon on
> that front - I'm acutely aware that this will be impacted aswell but
> because it's vaguely RT related had banded it under that banner.

Stepping back a moment.  The only way I can see this working reliably
is if we disable the boot interrupt.  Anything that leaves the boot interrupt
enabled means that when we disable the primary interrupt the boot interrupt
will scream, and thus we must disable it as well.

Which leads to my problem with the entire development process of this feature.

 People want the feature.
 People don't want to pay attention to the limits of the hardware.
 Which leads to countless broken patches proposed.

Which leads me to conclude.
- IRQ handling in the RT kernel is hopelessly broken.
- IRQ threads are a bad idea.

Because it is all leading to stupid patches and stupid development.

None of this works reliably on level triggered ioapic irqs.

Eric
