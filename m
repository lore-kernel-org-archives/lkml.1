Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbXFLVta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbXFLVta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXFLVtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:49:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:31880 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXFLVtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JAiirL1rjaAmcKMokdjZQrO0ywk/N5bH4lqI/VfNx9pUTINXjnLxaxTs70BZxwzfnf7IR8Z6CQdGhAnxVCO1aiFQ3e1dWlPu3xxChe2rwYk5wJgqifTx29Vk/BaYr3dS2gh/RgwsM7AkHNW0PyRpRdgFHFW+rC2GoKcnQvAmiVA=
Message-ID: <32209efe0706121449j7a973d5w47c9ff0efe916bcd@mail.gmail.com>
Date: Tue, 12 Jun 2007 14:49:01 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: linux-kernel@vger.kernel.org, rdreier@cisco.com
Subject: Re: FW: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
Cc: akpm@linux-foundation.org, vgoyal@in.ibm.com
In-Reply-To: <32209efe0706121432w705bfe51yb45f4fd08544267b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0EB7@USRV-EXCH4.na.uis.unisys.com>
	 <32209efe0706121432w705bfe51yb45f4fd08544267b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Natalie Protasevich <protasnb@gmail.com> wrote:
> >
> > From: Roland Dreier [mailto:rdreier@cisco.com]
> > Sent: Tuesday, June 12, 2007 1:14 PM
> > To: linux-kernel@vger.kernel.org; Protasevich, Natalie; Vivek Goyal
> > Cc: akpm@linux-foundation.org
> > Subject: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y
> > build broken
> >
> > (sending to Vivek since he seems to be one of the last people to touch
> > this code)
> >
> > For some strange reason I found myself compiling a kernel with
> > CONFIG_X86_ES7000 and CONFIG_ACPI set and CONFIG_X86_GENERICARCH not
> > set.  It died with
> >
> >     arch/i386/kernel/built-in.o: In function `acpi_parse_madt':
> >     boot.c:(.init.text+0x68b7): undefined reference to
> > `acpi_madt_oem_check'
> >     arch/i386/kernel/built-in.o: In function `get_smp_config':
> >     (.init.text+0x9f98): undefined reference to `mps_oem_check'
> >     arch/i386/kernel/built-in.o: In function `connect_bsp_APIC':
> >     (.init.text+0xa340): undefined reference to `enable_apic_mode'
> >     arch/i386/kernel/built-in.o: In function `connect_bsp_APIC':
> >     (.init.text+0xa370): undefined reference to `enable_apic_mode'
> >
> > this seems to be because eg acpi_madt_oem_check() and mps_oem_check()
> > are defined in arch/i386/mach-generic/es7000.c, but arch/i386/Makefile
> > only goes into mach-generic if CONFIG_X86_GENERICARCH is set.
> > I didn't track down why enable_apic_mode is broken yet.
> >
> > No patch because I don't understand how this subarch stuff is supposed
> > to build :(
> >
> >  - R.
> >
>
> Roland,
> I can't reproduce the problem, with the git tree I just pulled. Can
> you please provide the config file?
Sorry, never mind - I just did...Will look at it also.
Thanks,
--Natalie
