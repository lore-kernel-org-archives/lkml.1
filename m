Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbYKMIHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbYKMIHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYKMIHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:07:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYKMIHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:07:01 -0500
Subject: Re: [PATCH] SYSVIPC - Fix the ipc structures initialization
From: Peter Zijlstra <peterz@infradead.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cboulte@gmail.com,
       Nadia.Derbey@bull.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <491BC4B8.1050406@colorfullife.com>
References: <20081028145952.620752409@bull.net>
	 <20081028150041.857635775@bull.net>
	 <4f3ee3290810290211y75a2d0eaoe666496e25496260@mail.gmail.com>
	 <20081111141603.f0e7fa8d.akpm@linux-foundation.org>
	 <491BC4B8.1050406@colorfullife.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Nov 2008 09:06:34 +0100
Message-Id: <1226563594.7685.4394.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 07:10 +0100, Manfred Spraul wrote:
> Andrew Morton wrote:
> > Time is starting to press on this one.  Is there something which we can
> > revert which would fix this bug?
> >   
> My previous analysis was bogus, let's start from scratch:
> 
> 1) the initial oops report:
> http://bugzilla.kernel.org/show_bug.cgi?id=11796#c0
> 
> - lockdep is enabled, the oops is somewhere in __lock_acquire
> - the instruction that oopses is

> For me, it reads like an uninitialized spinlock_t:

Yes, most (if not all) oopsen in either __lock_acquire or __lock_release
are stomped on spinlocks, either use after free or otherwise.
