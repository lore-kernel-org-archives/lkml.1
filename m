Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYGUAh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYGUAh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYGUAhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:37:17 -0400
Received: from aun.it.uu.se ([130.238.12.36]:45677 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbYGUAhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:37:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18563.55832.673541.202465@harpo.it.uu.se>
Date: Mon, 21 Jul 2008 02:36:40 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: PIC, L-APIC and I/O APIC debug information
In-Reply-To: <Pine.LNX.4.55.0807202226310.24038@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807202226310.24038@cliff.in.clinika.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki writes:
 >  Dump all the PIC, local APIC and I/O APIC information at the
 > fs_initcall() level, which is after ACPI (if used) has initialised PCI
 > information, making the point of invocation consistent across MP-table and
 > ACPI platforms.  Remove explicit calls to print_IO_APIC() from elsewhere.  
 > Make the interface of all the functions involved consistent between 32-bit
 > and 64-bit versions and make them all static by default by the means of a
 > New-and-Improved(TM) __apicdebuginit() macro.
...
 > +#define __apicdebuginit(type) static type __init
...
 > -void __init print_IO_APIC(void)
 > +
 > +__apicdebuginit(void) print_IO_APIC(void)
 >  {

I _really_ dislike how this abuses the C macro preprocessor
to create pointless new syntax.

Since you're editing these function definitions anyway why
not just spell out "static void __init" in readable proper C?

/Mikael
