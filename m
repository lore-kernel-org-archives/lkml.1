Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbXIQU4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbXIQU4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXIQU4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:56:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25239 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbXIQU4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:56:10 -0400
Date: Mon, 17 Sep 2007 13:55:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] Immediate Values - Documentation
Message-Id: <20070917135522.b2e0fd99.randy.dunlap@oracle.com>
In-Reply-To: <20070917184321.186874558@polymtl.ca>
References: <20070917184224.549435917@polymtl.ca>
	<20070917184321.186874558@polymtl.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 14:42:30 -0400 Mathieu Desnoyers wrote:

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  Documentation/immediate.txt |  228 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 228 insertions(+)
> 
> Index: linux-2.6-lttng/Documentation/immediate.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/Documentation/immediate.txt	2007-09-17 14:03:09.000000000 -0400
> @@ -0,0 +1,228 @@
> +		        Using the Immediate Values
> +
> +			    Mathieu Desnoyers
> +
> +
> +This document introduces Immediate Values and their use.
> +
> +* Purpose of immediate values
> +
[snip]
> +
> +If you have to read the immediate values from a function declared as __init or
> +__exit, you should explicitly use _immediate_read(), which will fall back on a
> +global variable read. Failing to do so will leave a reference to the __init
> +section after it is freed (it would generate a modpost warning).
> +
> +The prefered idiom to dynamically enable compiled-in code is to use

       preferred

> +immediate_if (&this_immediate), which may eventually use gcc improvements to
> +provide a jump instruction patching based condition instead of a immediate value

                                                                  an

> +feeding a conditional jump. You should use _immediate_if () instead of
> +immediate_if () in functions marked __init or __exit.
> +
> +immediate_set_early() should be used only at early kernel boot time, before SMP
> +is activated. It provides no locking, does not take care of clearing the
> +write-protection bits when touching executable pages and does not take care or

                                                           does not take care of ??

> +SMP errata on the i386 and x86_64 architectures. By not doing so, it can update
> +the immediate values very early at kernel boot time and require the minimalistic

                                                          require only the

> +infrastructure available at that point.
> +
> +You can choose to set an initial static value to the immediate by using, for
> +instance:
> +
> +DEFINE_IMMEDIATE(long, myptr) = 10;
> +
> +
[snip]
> +
> +(15348 exec/s) * (7.84 cycles/exec) / (3G cycles/s) = 0.00004
> +For a 0.004% slowdown.
> +
> +If we plan to use this for memory allocation, spinlock, and all sort of

                                                              all sorts of

> +very high event rate tracing, we can assume it will execute 10 to 100
> +times more sites per second, which brings us to 0.4% slowdown with the
> +instruction stream based test compared to 29% slowdown with the memory
> +load based test on a system with high memory pressure.
> +
> +
[snip]
> +
> +
> +- Test redone with less iterations, but with error estimates
> +
> +10 runs of 100 iterations each: Tests done on a 3GHz P4. Here I run getppid with
> +syscall trace inactive, comparing the case with memory pressure and withou

                                                  last word:  without

> +memory pressure. (sorry, my system is not setup to execute syscall_trace this
> +time, but it will make the point anyway).
> +
[snip]
> +
> +
> +Therefore, not only is it interesting to use the immediate values to dynamically
> +activate dormant code such as the markers, but I think it should also be
> +considered as a replacement for many of the "read mostly" static variables.

                                               "read-mostly"

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
