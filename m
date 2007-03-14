Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXCNPy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXCNPy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXCNPy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:54:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXCNPyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:54:25 -0400
Date: Wed, 14 Mar 2007 08:54:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070314125330.GA13168@elte.hu>
Message-ID: <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Ingo Molnar wrote:
>
> and that's how i think unification of architectures should be done: move 
> code into kernel/* and drivers/*, _not_ into another architecture. That 
> way all architectures benefit.

Don't be silly.

Did you even *look* at the patches?

We're talking about things like

	b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h

so please tell me what drugs you are on that say that we should move this 
into kernel/* and drivers/* and make all architectures benefit. It's 
*x86* specific, it's just that k8 exists both in 32-bit and 64-bit land.

The file is *already* shared, it's just that right now it is not in a 
shared location. Right now it is in arch/i386/ (as if it was 
i386-specific) and then x86-64 includes it with:

arch/x86_64/kernel/cpufreq/Makefile:

	#
	# Reuse the i386 cpufreq drivers
	#
	
	SRCDIR := ../../../i386/kernel/cpu/cpufreq

and anybody who thinks this is "nice" simply has no taste at all.

		Linus
