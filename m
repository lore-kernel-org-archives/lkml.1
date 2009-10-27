Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZJ0DuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZJ0DuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZJ0DuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:50:23 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:50143 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbZJ0DuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IU08obNV1VF1y8DmwnpbdYVPa8JnwbALI1KiAegxZv9n3Fhzyjpm5rYb3VPlDCC4w2
         H5NmIY04MYNSy+TF+GZKMSF6KGERngzIgwPHLsbDnpSV0Ao4lyr5+DRs2NYlsTgaHnoh
         dPOhc5etjInZgCST0YnlGTyUR3vbpSmdC+ao0=
MIME-Version: 1.0
In-Reply-To: <20091013071805.GC13175@elte.hu>
References: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com>
	 <alpine.LSU.2.00.0910091706350.19284@wotan.suse.de>
	 <20091012202613.GB7648@elte.hu>
	 <alpine.LSU.2.00.0910130031420.19284@wotan.suse.de>
	 <20091013071805.GC13175@elte.hu>
Date: Tue, 27 Oct 2009 11:50:27 +0800
Message-ID: <3877989d0910262050o289ae12bgd7242aa5614ad94b@mail.gmail.com>
Subject: Re: [trivial PATCH] fix typo in nmi.c of apic
From: Luming Yu <luming.yu@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 3:18 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jiri Kosina <jkosina@suse.cz> wrote:
>
>> On Mon, 12 Oct 2009, Ingo Molnar wrote:
>>
>> > > > I came across x86/kernel/apic/nmi.c and found several typo.
>> > > > It's trivial in terms of doing nothing on changing execution logic.
>> > > I'd rather go this through x86 tree. Adding Ingo.
>> > >
>> > > > Ps. The patch is enclosed in attachment. The inline one
>> > > > is c&p of it for reading.
>> > > >
>> > > >
>> > > > Thanks,
>> > > > Luming
>> > > >
>> > > > Signed-off-by: Yu Luming <luming.yu@intel.com>
>> > > >
>> > > >  nmi.c |   18 +++++++++---------
>> > > >  1 file changed, 9 insertions(+), 9 deletions(-)
>> > > >
>> > > > diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
>> > > > index b3025b4..9ff1f6d 100644
>> > > > --- a/arch/x86/kernel/apic/nmi.c
>> > > > +++ b/arch/x86/kernel/apic/nmi.c
>> > > > @@ -121,7 +121,7 @@ static void report_broken_nmi(int cpu, unsigned
>> > > > int *prev_nmi_count)
>> > > >         atomic_dec(&nmi_active);
>> > > >  }
>> > > >
>> > > > -static void __acpi_nmi_disable(void *__unused)
>> > > > +static void __apic_nmi_disable(void *__unused)
>> >
>> > that's correctly named, as a 'git grep acpi_nmi_disable' should reveal.
>>
>> I actually think that Luming Yu is right that the function is misnamed.
>> What does it have to do with ACPI?
>
> It's not misnamed - it is a facility provided by architecture code to
> the ACPI subsystem and hence named acpi_*(). See:
>
>  5d0e600: [PATCH] x86: fix laptop bootup hang in init_acpi()

Hmm..I would put some comments around those "__acpi_xxx",
so others can know it is intended name.

>
> Other architectures could opt to implement the same quirk - but it has
> nothing to do with APIC.
>
> Yes, on x86 we use the local APIC to disable NMIs, but that has no
> effect on the naming of the facility ...
>
>        Ingo
>
