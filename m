Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbXFEKHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbXFEKHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764160AbXFEKHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:07:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:43578 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764026AbXFEKHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:07:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: lguest rebroken in 2.6.22-rc3-mm1
Date: Tue, 5 Jun 2007 12:01:31 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
References: <20070522223828.GV11115@waste.org> <200706042012.15915.ak@suse.de> <1181011737.25878.146.camel@localhost.localdomain>
In-Reply-To: <1181011737.25878.146.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051201.32137.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But TSC is a "required feature", so "cpu_has_tsc" is always true.

Hmm? It isn't. What makes you think so?

cpufeature.h:
#define cpu_has_tsc             boot_cpu_has(X86_FEATURE_TSC)

% grep -i tsc include/asm-i386/required-features.h
% 

> How about this patch:
> ===
> Don't try to disable the TSC: it's a required feature under modern
> configurations, so just mark the sched clock unstable which has the
> same effect.

No, using the cpuid bit is the correct way. Or better fix lguest to support
TSC properly. You cannot stay forever in the keep-it-over-simple Minix trap anyways.

-Andi

 
