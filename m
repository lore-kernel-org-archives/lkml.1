Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYFSElS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYFSElS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 00:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYFSElH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 00:41:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36542 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYFSElG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 00:41:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Len Brown" <lenb@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com>
	<200805191252.36814.yhlu.kernel@gmail.com>
	<200805251600.26325.yhlu.kernel@gmail.com>
	<200806011317.38622.yhlu.kernel@gmail.com>
	<alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
	<86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
	<alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
	<86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
Date: Wed, 18 Jun 2008 21:32:01 -0700
In-Reply-To: <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
	(Yinghai Lu's message of "Wed, 18 Jun 2008 17:49:16 -0700")
Message-ID: <m1mylim4e6.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: update mptable v7
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Wed, Jun 18, 2008 at 5:33 PM, Len Brown <lenb@kernel.org> wrote:
>>
>>
>> On Wed, 18 Jun 2008, Yinghai Lu wrote:
>>
>>> On Wed, Jun 18, 2008 at 3:18 PM, Len Brown <lenb@kernel.org> wrote:
>>> >
>>> >
>>> > On Sun, 1 Jun 2008, Yinghai Lu wrote:
>>> >
>>> >>
>>> >> make mptable to be consistent to acpi routing, so we could
>>> >> 1. kexec kernel with acpi=off
>>> >> 2. workaround BIOS that acpi routing is working, but mptable is not right.
>>> >> so can use kernel/kexec to start other os that doesn't have good acpi
> support
>>> >
>>> > Is this an effort to boot an ACPI-mode kernel,
>>> > and then kexec a non-ACPI kernel?
>>>
>>> Yes,
>>
>> Why is this feature needed?
>> There are a number of ways that the resulting kernel may fail,
>> all platform specific.
>
> other os still doesn't have update acpi irq routing support. but has
> broken mptable.

Which is at least in part a reason to go back to the BIOS manufacturer
and get them to fix their table.

I can see a warning coming from the kernel if these two tables are inconsistent
though.

>>> > Doing so could confuse the heck out of the platform firmware,
>>> > which will think that an ACPI-mode kernel is still running.
>>> >
>>> > Note that it is a historic artifact, now considered a bug,
>>> > that ACPI uses the MPS code.  We should be divorcing these
>>> > two bodies of code rather than mixing them further.
>>>
>>> how about adding config option to not compile mptable related info?
>>
>> That's the idea.
>> CONFIG_MPS=n CONFIG_ACPI=y should build and run on
>> every PC built in this century.
>>
>> This was prototyped a long while back, but the
>> tree has churned so much since then the old
>> prototype is worthless.
>
> will look at it tonight.
>
> when EFI is popular, there is no reason to compile mps related stuff
> in kernel again. esp for 64 bit.

? EFI has nothing to do with this.  ACPI is popular today and EFI preserves
EFI.

> BTW, it is funny that Suse still has fallsafe boot entry with acpi=off.

Silly question.  Given that even writing to this table is platform specific.
Any chance we can do this any a userspace utility writing through /dev/mem
for the systems that need it?   We can even bundle the utility in the kexec-tools
package to make it easier to distribute.

Eric
