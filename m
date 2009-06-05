Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZFEO4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZFEO4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZFEO4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:56:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755955AbZFEO4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:56:01 -0400
Date: Fri, 5 Jun 2009 07:54:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <200906051416.19311.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.01.0906050753550.6847@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <200906051416.19311.rusty@rustcorp.com.au>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Jun 2009, Rusty Russell wrote:
> 
> Distributions don't ship UP kernels any more; this shows what that costs if 
> you're actually on a UP box.  If we really don't care, perhaps we should make 
> CONFIG_SMP=n an option under EMBEDDED for x86.  And we can rip out the complex 
> patching SMP patching stuff too.

The complex SMP patching is what makes it _possible_ to not ship UP 
kernels any more.

The SMP overhead exists, but it would be even higher if we didn't patch 
things to remove the "lock" prefix.

		Linus
