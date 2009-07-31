Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbZGaVck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbZGaVck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZGaVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:32:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbZGaVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:32:39 -0400
Date: Fri, 31 Jul 2009 14:31:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] information leak in sigaltstack
In-Reply-To: <alpine.LFD.2.01.0907311407040.24841@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907311428370.3304@localhost.localdomain>
References: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.01.0907311407040.24841@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Jul 2009, Linus Torvalds wrote:
> 
> Now, you'd end up with a memset() in that case (since it certainly won't 
> match the offsetof), but my point is, the conditional really looks very 
> arbitrary and rather strange. I'd rather see it unconditional, even if it 
> costs three unnecessary writes or whatever.

.. and if we really do want the conditional, maybe just make it something 
like

	/*
	 * ss_flags is often generally 'int', and may cause
	 * holes in the structure due to alignment.
	 */
	if (alignof(oss.ss_flags) != alignof(oss))
		memset(&oss, 0, sizeof(oss));

instead? That would seem to be less subtle, and more to-the-point.

			Linus
