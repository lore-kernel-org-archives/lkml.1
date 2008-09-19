Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbYISNqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbYISNqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYISNqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:46:09 -0400
Received: from mail91.analogic.com ([208.224.220.31]:43887 "EHLO
	mail01.analogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192AbYISNqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:46:09 -0400
X-Greylist: delayed 1714 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2008 09:46:08 EDT
X-AuditID: 0a770115-aa67cbb0000014a6-2e-48d3a66e29e9
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 19 Sep 2008 13:17:12.0634 (UTC) FILETIME=[0729F9A0:01C91A5A]
Content-class: urn:content-classes:message
Subject: Re: [patch] x86, ptrace: void dopiness
Date: Fri, 19 Sep 2008 09:17:11 -0400
Message-ID: <Pine.LNX.4.61.0809190908470.11723@chaos.analogic.com>
In-Reply-To: <20080919145250.A6000@sedona.ch.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: void dopiness
Thread-Index: AckaWgdN2BdduIuiT9+MCjjz0f3y/w==
References: <20080919145250.A6000@sedona.ch.intel.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Markus Metzger" <markus.t.metzger@intel.com>
Cc: <mingo@elte.hu>, <markus.t.metzger@gmail.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008, Markus Metzger wrote:

> Remove void cast to explicitly ignore the return value.
>
>
> Signed-off-by: markus.t.metzger@intel.com
>
> ---
> Index: gits.x86/arch/x86/kernel/ptrace.c
> ===================================================================
> --- gits.x86.orig/arch/x86/kernel/ptrace.c	2008-06-30 13:21:07.%N +0200
> +++ gits.x86/arch/x86/kernel/ptrace.c	2008-09-19 13:53:02.%N +0200
> @@ -738,7 +738,7 @@
> 		unsigned int sig = 0;
>
> 		/* we ignore the error in case we were not tracing child */
> -		(void)ds_release_bts(child);
> +		ds_release_bts(child);
>
> 		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
> 			if (!cfg.signal)
> @@ -947,7 +947,7 @@
> 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
> #endif
> #ifdef CONFIG_X86_PTRACE_BTS
> -	(void)ds_release_bts(child);
> +	ds_release_bts(child);
>
> 	child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
> 	if (!child->thread.debugctlmsr)
> ---------------------------------------------------------------------
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen Germany
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
> Registergericht: Muenchen HRB 47456 Ust.-IdNr.
> VAT Registration No.: DE129385895
> Citibank Frankfurt (BLZ 502 109 00) 600119052

I don't agree. Casting the return value to void, since it
takes extra steps on the part of the writer, means that the
writer is deliberately ignoring the return value because
it has no objective use in the code.

Just letting unused return-values be ignored means that
the writer either wanted to ignore it or simply forgot
about it. The cast is supposed to remove doubt. Certain
user-mode functions that are obviously used for effect
like printf(), are exempt.

That said, putting a space between the cast and the
function name helps in the use of some text-scanning
tools and therefore improves maintainability.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.70 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged. Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
