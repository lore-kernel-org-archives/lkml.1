Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbXJKTvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbXJKTvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXJKTvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:51:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36026 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751632AbXJKTvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:51:39 -0400
Date: Thu, 11 Oct 2007 20:55:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Christoph Egger" <Christoph.Egger@amd.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Joerg Roedel" <joerg.roedel@amd.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mce init optimization and signedness fixup
Message-ID: <20071011205548.62af1b97@the-village.bc.nu>
In-Reply-To: <200710111703.35129.Christoph.Egger@amd.com>
References: <11921050742274-git-send-email-joerg.roedel@amd.com>
	<200710111601.02630.Christoph.Egger@amd.com>
	<alpine.LFD.0.9999.0710111651350.15917@localhost.localdomain>
	<200710111703.35129.Christoph.Egger@amd.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So when I change the above code snippet to:
> 
> +	if (!cpu_has(c, X86_FEATURE_MCE)) {
> +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> +			smp_processor_id());
> +		return;
> 
> Would this make the whole patch acceptable then?

I think the fundamental direction is wrong. "Do you have a machine check
like facility" is a CPU specific question that belongs in the CPU
specific code.

If some of that CPU specific code is wrong, fix it there.

Alan
