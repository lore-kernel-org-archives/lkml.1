Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZDNRC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZDNRC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbZDNRCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:02:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbZDNRCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:02:16 -0400
Date: Tue, 14 Apr 2009 09:57:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: tj@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
In-Reply-To: <20090414161053.28145.1209.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain>
References: <20090414161053.28145.1209.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Apr 2009, David Howells wrote:
> 
> To fix this, DECLARE_PER_CPU() should simply interpose the same section
> attribute as does DEFINE_PER_CPU().  However, this is made slightly more
> complex by virtue of the fact that there are several variants on DEFINE, so
> these need to be matched by variants of DECLARE.

This needs to be fixed.

We should have the DECLARE_PER_CPU() #defines next to the DEFINE_PER_CPU 
ones, rather than somewhere else.

So moving the logic to <asm-generic/percpu.h> is wrong - make it all be in 
<linux/percpu.h> so that they can be maintained together.

		Linus
