Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbXEKVxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbXEKVxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXEKVxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:53:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37981 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751555AbXEKVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:53:00 -0400
Date: Fri, 11 May 2007 22:56:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@muc.de>, systemtap@sources.redhat.com, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070511225645.1e256ea5@the-village.bc.nu>
In-Reply-To: <20070511180207.GA25516@Krystal>
References: <20070510015555.973107048@polymtl.ca>
	<20070510020916.508519573@polymtl.ca>
	<20070510090656.GA57297@muc.de>
	<20070510155501.GI22424@Krystal>
	<20070510172843.7aa72237@the-village.bc.nu>
	<20070510165918.GK22424@Krystal>
	<20070511060444.GA35262@muc.de>
	<20070511180207.GA25516@Krystal>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The IPI might be fast, but I have seen interrupts being disabled for
> quite a long time in some kernel code paths. Having interrupts disabled
> on _each cpu_ while running an IPI handler waiting to be synchronized
> with other CPUs has this side-effect. Therefore, if I understand well,

This can already occur worst case when we spin on an IPI (eg a cross CPU
TLB shootdown)

If the INT3 is acknowledged as safe by intel either as is or by some
specific usage like lock mov then great. If not it isn't too bad a
problem.

And to be real about this - how many benchmarks do you know that care
about mega-kernel-debugs per second ?
