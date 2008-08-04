Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbYHDTcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbYHDTcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbYHDTcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:32:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754402AbYHDTcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:32:14 -0400
Date: Mon, 4 Aug 2008 12:31:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
In-Reply-To: <489757EC.3000309@goop.org>
Message-ID: <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org>
References: <20080804130317.994042639@chello.nl>  <20080804131012.246115111@chello.nl>  <48974512.7000206@goop.org> <1217876046.3589.61.camel@twins> <489757EC.3000309@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Aug 2008, Jeremy Fitzhardinge wrote:
> 
> OK.  I don't actually need to do this, but I was asking for completeness.  But
> to clarify, you only need to do the reverse unlock if you do it after
> unlocking the outer lock?  If you're still holding the outer lock, you can
> unlock in any order?

Release order should always be totally irrelevant, whether you hold outer 
locks or not. Only the order of _getting_ locks matter.

And yes, if there is an outer lock, even the order of getting locks is 
irrelevant, as long as anybody who gets more than one inner lock always 
holds the outer one.

		Linus
