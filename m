Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbZLBG50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbZLBG50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZLBG5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:57:25 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:44854 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZLBG5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:57:25 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: Q, slab, kmemleak_erase() and redzone? 
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4B160A16.90703@cs.helsinki.fi>
References: <4B1502E3.4000304@cs.helsinki.fi> <1259690210.2121.233.camel@pc1117.cambridge.arm.com> <4B1609D0.6030809@cs.helsinki.fi> <4B160A16.90703@cs.helsinki.fi>
Date: Wed, 02 Dec 2009 15:57:18 +0900
Message-ID: <9890.1259737038@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pekka Enberg:
> > No, you are absolutely correct. Can you please send an updated patch to 
> > Catalin that adds a comment on top of the cpu_cache_get() call that 
> > explains why we need it there?
> 
> Doh, this was supposed to be a reply to Okajima's email :-).

Before I send a small patch, let me make sure about other small issues.

- How heavy is 'ac = cpu_cache_get(cachep)' (which will be inserted by
  the patch)?
  It will be compiled and executed regardless CONFIG_DEBUG_KMEMLEAK, and
  it is totally meaningless when DEBUG_KMEMLEAK is disabled. Can we
  ignore this loss?

- Should we add a condition 'if (objp)' before calling kmemleak_erase()?
  As Catalin wrote, it may be harmless. But setting NULL is unnecessary.
  Do you accept this change too?


J. R. Okajima
