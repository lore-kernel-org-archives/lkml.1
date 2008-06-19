Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYFSSv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYFSSv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYFSSvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:51:51 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64632 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752837AbYFSSvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:51:50 -0400
Date: Thu, 19 Jun 2008 19:48:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Len Brown <lenb@kernel.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let MPS support selectable
In-Reply-To: <alpine.LFD.1.10.0806191350530.3040@localhost.localdomain>
Message-ID: <Pine.LNX.4.55.0806191920080.12929@cliff.in.clinika.pl>
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200806181432.57204.yhlu.kernel@gmail.com> <200806181729.31464.yhlu.kernel@gmail.com>
 <200806190018.45944.yhlu.kernel@gmail.com> <Pine.LNX.4.55.0806191600290.12929@cliff.in.clinika.pl>
 <86802c440806191039q5c6a2266p82d319a61a3bba3c@mail.gmail.com>
 <alpine.LFD.1.10.0806191350530.3040@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008, Len Brown wrote:

> CONFIG_ACPI_BOOT was removed because it was fundamentally ill-conceived
> and created a situation which was not only more difficult to maintain
> but also didn't work on most machines.
> ACPI interrupt configuration depends on the ACPI interpreter, so to boot
> properly and configure interrupts with ACPI, you need 90% of the kernel's
> ACPI code present anyway.

 Fair enough.

> If you want to use ACPI just for enumerating processors, ie to see
> the HT that MPS usually doesn't include, you can boot with "acpi=ht",
> which will not enter ACPI mode or use ACPI for anything else.

 Hmm, that's quite obscure an option name!  I would imagine most modern
systems used as servers would not want to do any power management, but
would still prefer to use ACPI for enumeration of processors (including
real ones!) and interrupts, because I gather it has become common if an MP
table is included in a system at all, it is not exactly correct, because
the responsible BIOS engineer simply had no clue to either fix it or
discard entirely.

> I don't think we should be going out of our way to enhance MPS support.
> There probably isn't a single system shipped in this century that has MPS
> that doesen't have ACPI, while there are millions of systems that
> have ACPI and no MPS.  MPS is going away, and making

 It looks like I have a fortunate exception, manufactured Dec 2007, which
has both in quite a good shape. :)

> it a config option prepares us for the day when we completely
> don't care about it any more.

 Well, this is why I think it is important to be able to drop unwanted
parts of the framework, such as the P from the ACPI acronym.  If you say
"acpi=ht" will do, that's great; otherwise relying on the MP table used to
be the alternative.

 I don't think we'll be able to drop MP table support entirely in the
foreseeable future though, like we haven't dropped support for the
original 80386 yet.  Old SMP systems with MP table support only are going
to be around for a while -- I have a couple myself and I am sure they are
still quite common.

> However, I think that adding CONFIG_MPS before removing ACPI's
> depencency on mpparse.c has all risk and no value.

 Agreed.

  Maciej
