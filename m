Return-Path: <linux-kernel-owner+w=401wt.eu-S1761058AbXGTMh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058AbXGTMh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbXGTMhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:37:11 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:57317 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbXGTMhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:37:10 -0400
Date: Fri, 20 Jul 2007 21:36:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm/Kconfig MEMORY_HOTPLUG typo ?
Message-ID: <20070720123649.GA27743@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Gabriel C <nix.or.die@googlemail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <46A0A954.4020102@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A0A954.4020102@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 02:23:48PM +0200, Gabriel C wrote:
> I'm a bit confused about the following from mm/Kconfig:
> 
> ..
> 
> config MEMORY_HOTPLUG
>         bool "Allow for memory hot-add"
>         depends on SPARSEMEM || X86_64_ACPI_NUMA
>         depends on HOTPLUG && !SOFTWARE_SUSPEND && ARCH_ENABLE_MEMORY_HOTPLUG
>         depends on (IA64 || X86 || PPC64 || SUPERH)
> 
MEMORY_HOTPLUG is only supported if !SOFTWARE_SUSPEND

> comment "Memory hotplug is currently incompatible with Software Suspend"
>         depends on SPARSEMEM && HOTPLUG && SOFTWARE_SUSPEND
> 
> 
> ...
> 
> That should be !SOFTWARE_SUSPEND no ?
> 
However, we only give the comment that warns about the incompatability
when SOFTWARE_SUSPEND is enabled, otherwise people won't see the option
due to the unmet dependency.
