Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbXDVBtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbXDVBtK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 21:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXDVBtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 21:49:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:56286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbXDVBtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 21:49:08 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Sunil Naidu" <akula2.shark@gmail.com>, linux-acpi@vger.kernel.org
Subject: Re: Linux 2.6.21-rc7 - ACPI issues? (Namespace lookup failure, AE_NOT_FOUND)
Date: Sat, 21 Apr 2007 21:47:47 -0400
User-Agent: KMail/1.9.5
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>
References: <8355959a0704210703n35b0dc35wcad04e5723eaec7@mail.gmail.com>
In-Reply-To: <8355959a0704210703n35b0dc35wcad04e5723eaec7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704212147.47926.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 10:03, Sunil Naidu wrote:
> Hello,
> 
> I did compile 2.6.21-rc7 for a P-III machine. Here is the ACPI part in
> the dmesg:-
> 
> ACPI Error (psargs-0355): [PRSE] Namespace lookup failure, AE_NOT_FOUND
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.LNKE._PRS] (Node dfd63f40), AE_NOT_FOUND
> ACPI Exception (pci_link-0180): AE_NOT_FOUND, Evaluating _PRS [20060707]
> ACPI Error (psargs-0355): [PRSF] Namespace lookup failure, AE_NOT_FOUND
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.LNKF._PRS] (Node dfd63ea0), AE_NOT_FOUND
> ACPI Exception (pci_link-0180): AE_NOT_FOUND, Evaluating _PRS [20060707]
> ACPI Error (psargs-0355): [PRSG] Namespace lookup failure, AE_NOT_FOUND
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.LNKG._PRS] (Node dfd63e00), AE_NOT_FOUND
> ACPI Exception (pci_link-0180): AE_NOT_FOUND, Evaluating _PRS [20060707]
> ACPI Error (psargs-0355): [PRSH] Namespace lookup failure, AE_NOT_FOUND
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.LNKH._PRS] (Node c147d75c), AE_NOT_FOUND
> ACPI Exception (pci_link-0180): AE_NOT_FOUND, Evaluating _PRS [20060707]
> 
> I tried with few configurations (config) to solve the problem, am not
> sure what's causing this failure. Any hint?


This is an AML run-time error from a PCI Interrupt Link
trying to find its "Present Resource Settings" --
ie. the current IRQ for a programmable IRQ.

Please open up a bug report here:
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

For 2.6.20.stable and the latest 2.6.21, please
build with CONFIG_ACPI_DEBUG=y, and
attach the complete output from dmesg -s64000
and paste the /proc/interrupts.

Also, please attach the output from acpidump
and lspci -vv taken from either boot.

thanks,
-Len
