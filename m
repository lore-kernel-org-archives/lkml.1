Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbYFSAvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbYFSAvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYFSAvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:51:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbYFSAvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:51:12 -0400
Date: Wed, 18 Jun 2008 17:49:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: benh@kernel.crashing.org, xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
 abstraction
In-Reply-To: <4859AA47.2020903@goop.org>
Message-ID: <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org>
References: <b020e42384197b824320.1213615800@localhost> <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org> <4859A528.1010107@goop.org> <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <4859AA47.2020903@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jun 2008, Jeremy Fitzhardinge wrote:
>
> It's not cmpxchg, just xchg. 
> In other words, is:
> 
> 	lock btr $_PAGE_BIT_RW, (%rbx)

Well, we can actually do it as

	lock andl $~_PAGE_RW,(%rbx)

although we haven't bothered (I've wanted several times to make 
clear_bit() do that, but have never gotten around to it - mainly because 
old gcc versions didn't work with __builtin_constant_p() in inline 
functions - so you have to do the macro from hell)

And yes, the "lock andl" should be noticeably faster than the xchgl.

			Linus
