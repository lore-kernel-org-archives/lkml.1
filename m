Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbZEGOR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbZEGOR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZEGORs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:17:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZEGORr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:17:47 -0400
Date: Thu, 7 May 2009 16:16:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, mingo@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH] x86: 46 bit PAE support
Message-ID: <20090507141642.GJ481@elte.hu>
References: <20090505172856.6820db22@cuia.bos.redhat.com> <4A00ED83.1030700@zytor.com> <4A0180AB.20108@redhat.com> <20090507120103.GA1497@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507120103.GA1497@ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> On Wed 2009-05-06 08:20:59, Rik van Riel wrote:
> > H. Peter Anvin wrote:
> >> Rik van Riel wrote:
> >>> Testing: booted it on an x86-64 system with 6GB RAM.  Did you really think
> >>> I had access to a system with 64TB of RAM? :)
> >>
> >> No, but it would be good if we could test it under Qemu or KVM with an
> >> appropriately set up sparse memory map.
> >
> > I don't have a system with 1TB either, which is how much space
> > the memmap[] would take...
> 
> Do we really have 1 byte overhead per 64 bytes of RAM?
> 								Pavel

Yes, struct page is ~64 bytes, and 64*64 == 4096.

Alas, it's not a problem: my suggestion wasnt to simulate 64 TB of 
RAM. My suggestion was to create a sparse physical memory map (in a 
virtual machine) that spreads ~1GB of RAM all around the 64 TB 
physical address space. That will test whether the kernel is able to 
map and work with such physical addresses. (which will cover most of 
the issues)

A good look at /debug/x86/dump_pagetables with such a system booted 
up would be nice as well - to make sure every virtual memory range 
is in its proper area, and that there's enough free space around 
them.

	Ingo
