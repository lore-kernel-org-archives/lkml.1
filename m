Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbYCKMP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbYCKMP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYCKMPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:15:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43446 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYCKMPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:15:21 -0400
Date: Tue, 11 Mar 2008 13:17:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: pageexec@freemail.hu, Ingo Molnar <mingo@elte.hu>,
       Srinivasa DS <srinivasa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 - Enhance DEBUG_RODATA support - alternatives
Message-ID: <20080311121714.GG18917@one.firstfloor.org>
References: <20080306140105.GC28438@elte.hu> <47D014E1.30964.22A9390F@pageexec.freemail.hu> <20080306172509.GA14284@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306172509.GA14284@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First, that calling this text_poke implementation to modify text in a
> module won't fail. Is virt_to_page(addr) ok if addr is in a vmalloc'ed
> area ?

virt_to_page only works on direct mapping addresses, not vmalloc.
> 
> Second, that calling virt_to_page(addr + PAGE_SIZE) won't have
> undesirable side-effects if addr happens to be in the last page of an
> allocated range. It should be ok for the core kernel text, because it is
> followed by the kernel rodata, but I am not certain for modules.

On non vmemmap/none flatmem kernels it could fail yes. But vmalloc/module_alloc
is not guaranteed to be continuous so you cannot do that anyways.

-Andi
