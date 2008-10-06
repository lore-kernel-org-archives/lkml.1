Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYJFU7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYJFU7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYJFU7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:59:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37272 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYJFU7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:59:39 -0400
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes (Re: 2.6.27-rc8+ - first impressions)
From: Andi Kleen <andi@firstfloor.org>
References: <20081005183603.GA3263@amd.corenet.prv>
	<200810060029.42471.rjw@sisk.pl>
	<20081006062235.GA2808@amd.corenet.prv>
	<200810061159.30103.rjw@sisk.pl>
	<alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org>
	<20081006150055.GA16930@elte.hu>
	<alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org>
Date: Mon, 06 Oct 2008 22:59:37 +0200
In-Reply-To: <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> (Maciej W. Rozycki's message of "Mon, 6 Oct 2008 18:51:20 +0100 (BST)")
Message-ID: <87tzbpmocm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Maciej W. Rozycki" <macro@linux-mips.org> writes:
>
>  This single instance of a piece of some HP gear being twisted beyond 
> belief is IMO a minor annoyance and price to pay compared to the gain.  
> Please note that apart from the DSDT being buggy on this machine, it has 
> an incorrect IRQ 0 override in the ACPI table pointing to the pin #2 of 
> the I/O APIC, which is in fact routed to the output of the master 8259A.  
> Additionally the pin #0 of the I/O APIC which is indeed routed to the 
> output of the 8254 does not receive any interrupts, presumably because of 
> some misconfiguration during BIOS initialisation. 

The real reason is actually a workaround in the BIOS for problems
in the older Linux code that caused duplicated timer interrupts. The
old Linux would fall into "enable both IO-APIC and 8259" fallback mode
and the resulted in duplicated timer events, which made everything unhappy.
They instead configured the northbridge in a way that one of the inputs
is ignored.

You won't be able to DMI list it, that workaround is widely used
in lots of different systems.

-andi
