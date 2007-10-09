Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbXJIQSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbXJIQSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbXJIQSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:18:18 -0400
Received: from barikada.upol.cz ([158.194.242.200]:45793 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXJIQSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:18:17 -0400
Date: Tue, 9 Oct 2007 18:32:30 +0200
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Christoph Egger <Christoph.Egger@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i386: mce cleanup part1: functional change
Message-ID: <20071009163230.GC22435@flower.upol.cz>
References: <11919341961890-git-send-email-joerg.roedel@amd.com> <11919341961530-git-send-email-joerg.roedel@amd.com> <E1IfHZg-0003dp-FA@flower> <20071009160605.GC13205@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009160605.GC13205@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 06:06:05PM +0200, Joerg Roedel wrote:
> > cpu_has() returns int,
> > but would it be better to have something like
> > 
> >   	if (!mce_disabled &&
> > 	    !(c->x86_capability & (X86_FEATURE_MCA | X86_FEATURE_MCE)) {
> > 		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > 			smp_processor_id());
> 
> This looks complicated and is harder to read. Its exactly the purpose of the
> cpu_has() macro to avoid such constructs.

It is done via test_bit(), which is designed for IO access with all that
`const volatile' stuff, 2 x unnecessary, can't be optimized here (IMHO).
____
