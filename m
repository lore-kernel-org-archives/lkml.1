Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYCYKLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYCYKLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYCYKLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:11:13 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:43370 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbYCYKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:11:13 -0400
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 6/8] x86_64: Define the macros and tables for the basic UV infrastructure.
References: <20080324182118.GA21758@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 11:11:11 +0100
In-Reply-To: <20080324182118.GA21758@sgi.com>
Message-ID: <87ej9zi05c.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 10:04:33.0695 (UTC) FILETIME=[9FF85AF0:01C88E5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner <steiner@sgi.com> writes:

> Define the macros and tables for the basic UV infrastructure.
> 
> 
> (NOTE: a work-in-progress. Pieces missing....)

Does the kernel really need all this information? You just want
to address the UV-APIC right? I suspect you could use a much stripped
down file.

> +DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
> +#define uv_hub_info 		(&__get_cpu_var(__uv_hub_info))
> +#define uv_cpu_hub_info(cpu)	(&per_cpu(__uv_hub_info, cpu))
> +
> +/* This header file is used in BIOS code that runs in physical mode */

Not sure what physical mode is.

> +#ifdef __BIOS__
> +#define UV_ADDR(x)		((unsigned long *)(x))
> +#else
> +#define UV_ADDR(x)		((unsigned long *)__va(x))
> +#endif

But it it would be cleaner if your BIOS just supplied a suitable __va()
and then you remove these macros.

-Andi
