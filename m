Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYFSHcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYFSHcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 03:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYFSHbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 03:31:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:56894 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbYFSHby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 03:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Cay4TUBYXiaMoHIk5mEkE/ZC10mHBRgF78cbBAVhIQ1ISZGiHSAXt6/p22AXYTN2aQ
         UKORaMwRbvGK5nVXDozwmOoE3TbM0tPlFbmtvVET7vO9MNoPEEklutvJKCU5HW5hwekT
         L05asD+nC+VdQY82IWosZZQO+dopOOZMakm0I=
Message-ID: <86802c440806190031q17049054md2a790224d30d29@mail.gmail.com>
Date: Thu, 19 Jun 2008 00:31:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: update mptable v7
Cc: "Len Brown" <lenb@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1abhilyl0.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200805251600.26325.yhlu.kernel@gmail.com>
	 <200806011317.38622.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
	 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
	 <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
	 <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
	 <m1mylim4e6.fsf@frodo.ebiederm.org>
	 <alpine.LFD.1.10.0806190121210.3613@localhost.localdomain>
	 <m1abhilyl0.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 11:37 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Len Brown <lenb@kernel.org> writes:
>
>>> >>> > Is this an effort to boot an ACPI-mode kernel,
>>> >>> > and then kexec a non-ACPI kernel?
>>> >>>
>>> >>> Yes,
>>> >>
>>> >> Why is this feature needed?
>>> >> There are a number of ways that the resulting kernel may fail,
>>> >> all platform specific.
>>> >
>>> > other os still doesn't have update acpi irq routing support. but has
>>> > broken mptable.
>>>
>>> Which is at least in part a reason to go back to the BIOS manufacturer
>>> and get them to fix their table.
>>
>> Who says it is broken?
>
> In the common case if not in general the MP table and the ACPI
> version of the same table, provide the same data in slight different
> formats.
>
>>> I can see a warning coming from the kernel if these two tables are
>> inconsistent
>>> though.
>>
>> Again, there may not *be* an MPS table, and if there is but the
>> interrupt links are programmable, the MPS table may have very little
>> in common with the state of the machine in ACPI mode.
>
> That I will believe.
>
>> I'm sorry, kexec continues to sound like science fiction to me.
>> I don't understand why scribbling on upstream Linux in the name
>> of science fiction makes any sense.
>>
>> I just don't get it.
>
> In the normal kexec case not the kexec on panic (aka kdump) we should
> have shutdown ACPI on the way down.  So the machine won't be running
> in ACPI mode.  I assume ACPI supports that.
>
> What YH is doing does sound potentially dangerous.  If you can indeed compare
> the two tables and in fact see they are inconsistent.  That is a good case
> for printing a warning message.  YH clearly started this because in his
> testing the MP table was broken and he had an older Enterprise kernel to run
> that had unusable ACPI support.  That however is a BIOS bug.  Pushing back
> on BIOS bugs and making them easy to find is always a good deal.  Silently
> fixing them (not just working around them) seems unprecedented.

the patch did print out the old and updated mptable.

and that feature is enabled via "update_mptable" command line.


also it is useful for kexec from acpi kernel to no acpi kernel on MB
with nvidia chipset with AMI BIOS.
becuase irq routing is different from mptable and acpi.

amd8111/amd8131 chipset with AMI bios has same irq routing from
mptable and acpi.

Phonix BIOS, has one setup option APIC/PIC, and if select APIC, then
irq routing from mptable and acpi is the same with
nvidia chipset.

YH
