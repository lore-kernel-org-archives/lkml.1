Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZENWcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZENWcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbZENWb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:31:59 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:60266 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435AbZENWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:31:58 -0400
From: Frans Pop <elendil@planet.nl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: idle: fix init-time TSC check regression
Date: Fri, 15 May 2009 00:31:54 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Janne Kulmala <janne.t.kulmala@tut.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain> <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905150031.57731.elendil@planet.nl>
X-OriginalArrivalTime: 14 May 2009 22:31:58.0695 (UTC) FILETIME=[CB1A8F70:01C9D4E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
>
> A previous 2.6.30 patch, a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2,
> (ACPI: idle: mark_tsc_unstable() at init-time, not run-time)
> erroneously disabled the TSC on systems that did not actually
> have valid deep C-states.
>
> Move the check after the deep-C-states are validated,
> via new helper, tsc_check_state(), hich replaces tsc_halts_in_c().

[...]

> @@ -603,6 +602,8 @@ static int acpi_processor_power_verify(struct
> acpi_processor *pr) 
>                                acpi_timer_check_state(i, pr, cx);
>                        break;
>                }
>+               if (cx->valid)
>+                       tsc_check_state(cx->type);
> 
>                if (cx->valid)
>                        working++;

Shouldn't those last two ifs not simply be combined?
Hmm. I guess not if tsc_check_state can change cx->valid, but that might 
be worth a comment.

But even with that I'll give the patch a try tomorrow.

Cheers,
FJP
