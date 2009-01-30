Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbZA3Br3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbZA3Br3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZA3BrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:47:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:41966 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbZA3BrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:47:21 -0500
Message-ID: <49825B90.8050400@kernel.org>
Date: Thu, 29 Jan 2009 17:44:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86/powernow: fix cpus_allowed brokage when acpi=off
References: <498136FC.2020206@kernel.org> <200901301210.48352.rusty@rustcorp.com.au>
In-Reply-To: <200901301210.48352.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 29 January 2009 15:26:28 Yinghai Lu wrote:
>> Impact: fix current->cpus_allowed overwriting.
> ...
>> caused by
>> | commit 2fdf66b491ac706657946442789ec644cc317e1a
>> | Author: Rusty Russell <rusty@rustcorp.com.au>
>> | Date:   Wed Dec 31 18:08:47 2008 -0800
>> |
>> |    cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var_t
> 
> Hi Yinghai!
> 
>    Indeed; Mike, that contained a bad conversion of 
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c.
> 
>    This patch reverts the bad change (this code should still be converted
> to work_on_cpu of course, but that's a bigger change).
> 
>    Yinghai, as far as I can tell your other fixes are independent (and
> were a problem before this commit, yes?).  Can you re-submit them on top
> of this patch (which is for Ingo, but against latest Linus).

no problem, after ingo pick your patch in tip/master, i will have another patch.

YH

> 
> Subject: cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
> 
> Impact: fix powernow-k8 when acpi=off (or other error).
> 
> There was a spurious change introduced into powernow-k8 in this patch:
> the cause if that we try to "restore" the cpus_allowed we never saved.
> 
> See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
> acpi=off" from Yinghai for the bug report.
> 
