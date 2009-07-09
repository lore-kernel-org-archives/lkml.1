Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZGIRbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZGIRbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZGIRbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:31:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbZGIRbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:31:38 -0400
Date: Thu, 9 Jul 2009 10:29:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netpoll: Fix carrier detection for drivers that are
 using phylib
In-Reply-To: <1247149862.12784.6.camel@twins>
Message-ID: <alpine.LFD.2.01.0907091027020.3352@localhost.localdomain>
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>  <20090708005000.GA12380@redhat.com> <1247034263.9777.24.camel@twins>  <alpine.LFD.2.01.0907080907210.3210@localhost.localdomain>  <20090708141024.f8b581c5.akpm@linux-foundation.org> 
 <20090708213331.GA9346@oksana.dev.rtsoft.ru>  <20090708144744.5555b88d.akpm@linux-foundation.org>  <20090708222003.GA12318@oksana.dev.rtsoft.ru>  <alpine.LFD.2.01.0907081701050.3352@localhost.localdomain>  <1247145977.21295.899.camel@calx> 
 <1247147206.7439.2.camel@twins>  <1247149093.21295.915.camel@calx> <1247149862.12784.6.camel@twins>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Jul 2009, Peter Zijlstra wrote:
> 
> So something like (utterly untested and such)

This looks like a good patch. Please make it so - who knows what other 
uses of cond_resched() we have in module init routines that might have 
deadlocks without it. The netpoll case got fixed, but please just do this.

I'd like to do my system_state movement too (the thing is, when you load 
drivers as modules you _will_ have "system_state == SYSTEM_RUNNING", so 
any initcall that depends on it being "early boot" is already broken), but 
there's no way that patch is appropriate for post-rc2. This one, however, 
looks appropriate (modulo getting some testing, of course)

		Linus
