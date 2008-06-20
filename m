Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYFTKjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYFTKjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYFTKjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:39:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbYFTKjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:39:39 -0400
Date: Fri, 20 Jun 2008 12:39:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix stack overflow for large values of MAX_APICS
Message-ID: <20080620103921.GC32500@elte.hu>
References: <20080620025104.GA25571@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620025104.GA25571@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> physid_mask_of_physid() causes a huge stack (12k) to be created if the 
> number of APICS is large. Replace physid_mask_of_physid() with a new 
> function that does not create large stacks. This is a problem only on 
> large x86_64 systems.

this indeed fixes the crash i reported here:

   http://lkml.org/lkml/2008/6/19/98

so i've added both this and the MAXAPICS patch to tip/x86/uv, and will 
test it some more. Lets hope it goes all well this time :-)

btw., it would be nice to have an ftrace plugin that prints out the 
worst-case stack footprint and generates an assert if we overflow the 
stack. -rt's kernel/latency_trace.c used to have that feature. That way 
incidents like this would be detected on the spot by -tip's 
auto-testing. The code in question is in kernel/trace/ftrace.c (and 
other nearby code).

	Ingo
