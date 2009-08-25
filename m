Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZHYJP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZHYJP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZHYJPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:15:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40776 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbZHYJPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:15:55 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
 memory  (f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251191478.15678.14.camel@pc1117.cambridge.arm.com>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
	 <1251191478.15678.14.camel@pc1117.cambridge.arm.com>
Date: Tue, 25 Aug 2009 12:15:55 +0300
Message-Id: <1251191755.26351.4.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 10:11 +0100, Catalin Marinas wrote:
> Yes, that's possible.
> 
> Does kmemcheck work on a page-range basis. If an object doesn't cross
> page boundaries, would it be considered fully initialised after writing
> a single location?
> 
> > I think it would be better to ask kmemcheck on a per-pointer basis
> > (i.e. for each pointer-sized word in the object), whether it is
> > initialized or not.
> 
> This should work but how expensive is this check?

Everything in kmemcheck is expensive :-). kmemcheck_shadow_lookup()
needs to do PTE lookup to find the shadow page where we record object
states. I'm not sure why that's a problem, though. If you've enabled
kmemcheck, everything is already dead slow and kmemleak scanning happens
in background, no? Furthermore, I think we need to do it the way Vegard
suggested to avoid false positives.

			Pekka

