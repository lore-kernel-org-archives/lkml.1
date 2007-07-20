Return-Path: <linux-kernel-owner+w=401wt.eu-S935179AbXGTPOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935179AbXGTPOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934142AbXGTPOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:14:34 -0400
Received: from ns.suse.de ([195.135.220.2]:49610 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933882AbXGTPOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:14:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
Date: Fri, 20 Jul 2007 17:14:16 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@mvista.com>
References: <200707191154.642492000@suse.de> <200707201027.46532.ak@suse.de> <20070720141210.GA29979@Krystal>
In-Reply-To: <20070720141210.GA29979@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201714.16811.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So if, after this, we run tsc_sched_clock() with an unstable TSC, we
> read a last_val containing the interrupt's MSB and the last_val LSB. It
> can particularity hurt if we are around a 32 bits overflow, because time
> could "jump" forward of about 1.43 seconds on a 3 GHz system.
> 
> So I guess we need synchronization on the fast path, and therefore using
> cmpxchg_local on x86_64

On x86-64 the 64bit write is atomic against interrupts.

You're right 32bit has a problem though. I'm not too happy about 
cmpxchg though because that wouldn't work on some CPUs.

I wonder if we can just get away with using a 32bit value on i386.
Just for the purpose of keeping the value monotonic it should be good
enough. Will think about it.

Thanks for the review.

-Andi

