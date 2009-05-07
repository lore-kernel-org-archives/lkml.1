Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZEGOtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZEGOtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZEGOtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:49:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbZEGOtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:49:40 -0400
Date: Thu, 7 May 2009 16:49:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, mingo@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH] x86: 46 bit PAE support
Message-ID: <20090507144904.GA2344@elte.hu>
References: <20090505172856.6820db22@cuia.bos.redhat.com> <4A00ED83.1030700@zytor.com> <4A0180AB.20108@redhat.com> <20090507120103.GA1497@ucw.cz> <20090507141642.GJ481@elte.hu> <4A02EFD2.40707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A02EFD2.40707@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
> > 
> > Yes, struct page is ~64 bytes, and 64*64 == 4096.
> > 
> > Alas, it's not a problem: my suggestion wasnt to simulate 64 TB of 
> > RAM. My suggestion was to create a sparse physical memory map (in a 
> > virtual machine) that spreads ~1GB of RAM all around the 64 TB 
> > physical address space. That will test whether the kernel is able to 
> > map and work with such physical addresses. (which will cover most of 
> > the issues)
> > 
> > A good look at /debug/x86/dump_pagetables with such a system booted 
> > up would be nice as well - to make sure every virtual memory range 
> > is in its proper area, and that there's enough free space around 
> > them.
> > 
> 
> We're working on simulating this at Intel.  We should hopefully be 
> able to test this next week.

Wow, very nice!

It would be nice to do it on a KVM basis and submit the 
weird-memory-layout submission to the KVM tree. It would be helpful 
with the reproduction of weird, memory layout dependent bugs too for 
example. Plus we could create a test facility that randomizes the 
physical memory layout (with a given fragmentation level).

	Ingo
