Return-Path: <linux-kernel-owner+w=401wt.eu-S1030471AbXCOPuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030471AbXCOPuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXCOPuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:50:50 -0400
Received: from dvhart.com ([64.146.134.43]:52770 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030471AbXCOPut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:50:49 -0400
Message-ID: <45F96B57.10206@mbligh.org>
Date: Thu, 15 Mar 2007 08:50:47 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 14 Mar 2007, Ingo Molnar wrote:
>> and that's how i think unification of architectures should be done: move 
>> code into kernel/* and drivers/*, _not_ into another architecture. That 
>> way all architectures benefit.
> 
> Don't be silly.
> 
> Did you even *look* at the patches?
> 
> We're talking about things like
> 
> 	b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> 
> so please tell me what drugs you are on that say that we should move this 
> into kernel/* and drivers/* and make all architectures benefit. It's 
> *x86* specific, it's just that k8 exists both in 32-bit and 64-bit land.
> 
> The file is *already* shared, it's just that right now it is not in a 
> shared location. Right now it is in arch/i386/ (as if it was 
> i386-specific) and then x86-64 includes it with:
> 
> arch/x86_64/kernel/cpufreq/Makefile:
> 
> 	#
> 	# Reuse the i386 cpufreq drivers
> 	#
> 	
> 	SRCDIR := ../../../i386/kernel/cpu/cpufreq
> 
> and anybody who thinks this is "nice" simply has no taste at all.

Can't we move the shared files into a new shared arch/ subdirectory
(ia32_64 or whatever), and have them included from both places?
At least then it's obvious they're shared, and it's a migration
strategy to the shared arch that you want.

On the downside, it's more ../../.. type stuff. On the upside,
they're more cleanly separated and it's apparent what's going on.
Seems nicer to me than drivers/ and kernel/ for stuff that's
really arch specific, but shared between two arches.

M.
