Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXEXWPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXEXWPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXEXWO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:14:58 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXEXWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:14:57 -0400
Message-ID: <46560E4F.2080009@zytor.com>
Date: Thu, 24 May 2007 15:14:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524150223.41063046.akpm@linux-foundation.org>
In-Reply-To: <20070524150223.41063046.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> I'm not sure I can be bothered repairing all that at present.  I think I'll
> go and hide until it becomes somebody else's problem.
> 

I'll fix it.

> <looks at hpa's tree>
> 
> @@ -23,13 +23,14 @@ static int show_cpuinfo(struct seq_file 
>                 "fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce",
>                 "cx8", "apic", NULL, "sep", "mtrr", "pge", "mca", "cmov",
>                 "pat", "pse36", "pn", "clflush", NULL, "dts", "acpi", "mmx",
> -               "fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", "pbe",
> +               "fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", NULL,
> 
> <wonders where pbe went to>

pbe collides with abuse by at least two vendors (AMD and
Cyrix/Centaur/VIA) of this bit for 3DNow.  I don't know if that applies
only to the chips that don't support extended CPUID levels, but I'm
fairly sure that we don't handle that correctly in the vendor-specific
handlers.

I guess for now we can just unconditionally disable that bit in those
vendor routines, with a note saying that if there are such chips
supporting PBE then more sophisticated logic needs to be implemented.

	-hpa
