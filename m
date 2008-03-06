Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbYCFLl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbYCFLl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYCFLlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:41:50 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:3339 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYCFLlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:41:49 -0500
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: show apicid for cpu in proc
References: <86802c440803060113s5b09c8b7w3a9da92ca15eff03@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Mar 2008 12:41:46 +0100
In-Reply-To: <86802c440803060113s5b09c8b7w3a9da92ca15eff03@mail.gmail.com>
Message-ID: <8763w0gjut.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2008 11:35:16.0309 (UTC) FILETIME=[262C1850:01C87F7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

>  			   cpus_weight(per_cpu(cpu_core_map, cpu)));
>  		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
>  		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
> +		seq_printf(m, "apicid\t: %02x\n", c->apicid);

Seems a little redundant with the boot log, but ok.

But it's unclear to the user which apic ID is meant by that. There are
two different ones. The one in the LAPIC mapping and the one reported by
CPUID. They are not necessarily the same. I think you should clarify that
by renaming the field or perhaps report both.

-Andi
