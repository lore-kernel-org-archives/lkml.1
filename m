Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZJFEjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZJFEjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZJFEjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:39:17 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:55456 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZJFEjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mdPm5kmMsICklwAMOY3yzCcrvm+vatPnu9HN+xiWkSiUmj8VXxxNo+FogtzheacuNi
         nTBvhvZbGuFru8AwZK0w/en0MbnVDmf8RS9KDGZ3/85ciHdewsTN6PETNPGnSkMk/M/R
         3x64tYnxCTd5U1qiOfdUHVNGjk5Z8QCnCwlcY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910052312140.309@localhost.localdomain>
References: <200908072333.24631.storm@sys49152.net>
	 <alpine.LFD.2.00.0908122350560.22946@localhost.localdomain>
	 <200908160400.03391.storm@sys49152.net>
	 <alpine.LFD.2.00.0910052312140.309@localhost.localdomain>
Date: Mon, 5 Oct 2009 21:38:40 -0700
Message-ID: <86802c440910052138i211dce8apd50cc3558b24de44@mail.gmail.com>
Subject: Re: Regression in ACPI in 2.6.31-rc5
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> Subject: [PATCH] Revert "x86/pci: remove rounding quirk from e820_setup_gap()"
>
> This reverts commit 5d423ccd7ba4285f1084e91b26805e1d0ae978ed.
>
> because it caused multiple regressions in 2.6.31-rc1
>
> http://bugzilla.kernel.org/show_bug.cgi?id=13940
>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>
> Yinghai,
> is there a reason we should not revert the offending patch, per below?

that patch is introduced fix another bug to get enough resource.

and that patch looks like reveal some bug in ACPI (?) because when
apci subsystem is enabled,
some BARs of some pci devices get cleared somehow.

actually there is patch that could workaround the problem too

---
 arch/x86/kernel/e820.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1378,8 +1378,8 @@ static unsigned long ram_alignment(resou
 	if (mb < 16)
 		return 1024*1024;

-	/* To 32MB for anything above that */
-	return 32*1024*1024;
+	/* To 64MB for anything above that */
+	return 64*1024*1024;
 }

 #define MAX_RESOURCE_SIZE ((resource_size_t)-1)

but Linus wants to know why those BARs get cleared, and who is using
that extra 32M.

It seems some guys request acpidump from the reporter, and not sure
what is the result from their checking.
or need the reporter to boot with acpi.debug_layer=0x400000
acpi.debug_level=0x04000807
to pull out more result?

YH
