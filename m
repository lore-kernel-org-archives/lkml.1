Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbXD0UC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbXD0UC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbXD0UC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:02:56 -0400
Received: from hu-out-0506.google.com ([72.14.214.229]:46262 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbXD0UCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=WzPcYpKL+nUtH0CmuGE4mO7ewjtTyFnGtdPYkjokuDuSYwRUNhsd17Auwng+ifWImLFOS9nHNdltYRJP3Uf8jsc37OEzCu2VymYALrZHG2hQQsZzi+r4cFfpSs9lTo7AWoLKq3iUL8lIoccn9Jkc7niz3+/mTQcDVgDwNOGyQok=
Date: Fri, 27 Apr 2007 22:02:47 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: linux-kernel@vger.kernel.org, oliver pinter <oliver.pntr@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [BUG? -rc7] SMP: Just one CPU activated: P4 3GHz HT
Message-ID: <20070427200247.GA7270@dreamland.darkstar.lan>
References: <fa.2kDN6AWFnkWM37pP5//wKJmbvRQ@ifi.uio.no> <462BF4DF.7080401@shaw.ca> <653402b90704230111p50b72586te73c1288f12a0079@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <653402b90704230111p50b72586te73c1288f12a0079@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Mon, Apr 23, 2007 at 10:11:52AM +0200, Miguel Ojeda ha scritto: 
> On 4/22/07, Luca Tettamanti <kronos.it@gmail.com> wrote:
> >Probably the two siblings are enumerated only in ACPI tables. If you
> >disable ACPI the kernel won't be aware of the second "core".
> >
> >Luca
> >--
> >"Su cio` di cui non si puo` parlare e` bene tacere".
> > Ludwig Wittgenstein
> >
> 
> On 4/23/07, Robert Hancock <hancockr@shaw.ca> wrote:
> >
> >You didn't enable ACPI, it's needed for almost all systems to detect HT
> >and also for many systems to detect multi-cores as well.
> >
> >Aside from that, in general I would say that on any modern x86 system
> >ACPI should always be enabled. In many cases it seems the BIOS code is
> >not tested much without ACPI anymore, so going without ACPI can be
> >problematic.
> >
> >--
> >Robert Hancock      Saskatoon, SK, Canada
> >To email, remove "nospam" from hancockr@nospamshaw.ca
> >Home Page: http://www.roberthancock.com/
> >
> >
> 
> Thanks all of you. It seems the problem is ACPI, however, should not
> it be noted in some way? Maybe at Documentation/smp.txt, maybe at the
> help section at CONFIG_SMP, maybe a "depends on ..."
>
> Or maybe CONFIG_SMP should enable some bits of the ACPI code needed to
> detect such additional cores.

"depends on" is too strong. There exists architecture without ACPI but
with SMP support; even in the x86 world a number of systems still
support both MPS and ACPI.

Mentioning it in the help text should be enough. Roman, are you in
charge for the KConfig files?

---
SMP support in modern systems often relies on ACPI being active; add a
couple of lines in the help text for CONFIG_SMP

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>
---

 arch/i386/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 53d6237..48ef899 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -111,6 +111,9 @@ config SMP
 	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
 	  Management" code will be disabled if you say Y here.
 
+	  Note that ACPI is often required to support newer multi-core CPUs
+	  and HT on Intel P4 processors.
+
 	  See also the <file:Documentation/smp.txt>,
 	  <file:Documentation/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at




Luca
-- 
"Vorrei morire ucciso dagli agi. Vorrei che di me si dicesse: ``Com'è
morto?'' ``Gli è scoppiato il portafogli''" -- Marcello Marchesi
