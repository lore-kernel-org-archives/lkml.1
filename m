Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZAMD6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZAMD6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZAMD57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:57:59 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56835 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbZAMD55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:57:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Jon Masters <jcm@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
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
	<20090113014723.GA11366@elte.hu>
Date: Mon, 12 Jan 2009 19:47:32 -0800
In-Reply-To: <20090113014723.GA11366@elte.hu> (Ingo Molnar's message of "Tue,
	13 Jan 2009 02:47:23 +0100")
Message-ID: <m1prirx3xn.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
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

Ingo Molnar <mingo@elte.hu> writes:

> * Jon Masters <jcm@redhat.com> wrote:
>
>> On Mon, 2009-01-12 at 15:36 -0800, Eric W. Biederman wrote:
>> 
>> > This hardware behavior is not specific to boot interrupts or Intel.
>> 
>> It's not specific to Intel, but it is a specific compatibility behavior.
>> 
>> > Is this case really so interesting and compelling that we want to 
>> > fight through and figure what we need to do to make this work reliably 
>> > on every x86 chipset?
>> 
>> How else do you propose implementing IRQ handling in e.g. the RT kernel? 
>> We get a hardware interrupt, we can't FastEOI, we can't process 
>> synchronously, we can't do all of those things you might expect. 
>> Implementing RT requires that we delay handling of the IRQ until 
>> arbitrarily later in the future when we get around to it.
>
> a number of mainline drivers also mask/unmask irqs from within the IRQ 
> handler. It's not particularly smart in a native driver, but can happen - 
> and if we get an active line after that point (and this can happen because 
> the driver is active), we are in trouble.

Yep.  Right now it might be simpler to fix the mainline drivers.

If we can sit down and write some nice clean obviously correct patches
I am all for fixing this bug, possibly even a chipset at a time.

However this is a really weird case and people seem to be really struggling
to understand what is going on and to write those patches.  We are outside
the descriptions provided by ACPI so it requires chipset specific knowledge,
and a general understanding of how chipsets work to actually even comprehend
the problem.

Eric
