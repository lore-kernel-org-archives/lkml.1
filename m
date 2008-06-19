Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYFSGlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYFSGlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 02:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYFSGlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 02:41:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47597 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYFSGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:41:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Len Brown <lenb@kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com>
	<200805191252.36814.yhlu.kernel@gmail.com>
	<200805251600.26325.yhlu.kernel@gmail.com>
	<200806011317.38622.yhlu.kernel@gmail.com>
	<alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
	<86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
	<alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
	<86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
	<m1mylim4e6.fsf@frodo.ebiederm.org>
	<alpine.LFD.1.10.0806190121210.3613@localhost.localdomain>
Date: Wed, 18 Jun 2008 23:37:31 -0700
In-Reply-To: <alpine.LFD.1.10.0806190121210.3613@localhost.localdomain> (Len
	Brown's message of "Thu, 19 Jun 2008 01:27:38 -0400 (EDT)")
Message-ID: <m1abhilyl0.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Len Brown <lenb@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: update mptable v7
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

>> >>> > Is this an effort to boot an ACPI-mode kernel,
>> >>> > and then kexec a non-ACPI kernel?
>> >>>
>> >>> Yes,
>> >>
>> >> Why is this feature needed?
>> >> There are a number of ways that the resulting kernel may fail,
>> >> all platform specific.
>> >
>> > other os still doesn't have update acpi irq routing support. but has
>> > broken mptable.
>> 
>> Which is at least in part a reason to go back to the BIOS manufacturer
>> and get them to fix their table.
>
> Who says it is broken?

In the common case if not in general the MP table and the ACPI 
version of the same table, provide the same data in slight different
formats.

>> I can see a warning coming from the kernel if these two tables are
> inconsistent
>> though.
>
> Again, there may not *be* an MPS table, and if there is but the
> interrupt links are programmable, the MPS table may have very little
> in common with the state of the machine in ACPI mode.

That I will believe.

> I'm sorry, kexec continues to sound like science fiction to me.
> I don't understand why scribbling on upstream Linux in the name
> of science fiction makes any sense.
>
> I just don't get it.

In the normal kexec case not the kexec on panic (aka kdump) we should
have shutdown ACPI on the way down.  So the machine won't be running
in ACPI mode.  I assume ACPI supports that.

What YH is doing does sound potentially dangerous.  If you can indeed compare
the two tables and in fact see they are inconsistent.  That is a good case
for printing a warning message.  YH clearly started this because in his
testing the MP table was broken and he had an older Enterprise kernel to run
that had unusable ACPI support.  That however is a BIOS bug.  Pushing back
on BIOS bugs and making them easy to find is always a good deal.  Silently
fixing them (not just working around them) seems unprecedented.

Eric
