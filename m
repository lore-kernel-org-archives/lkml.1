Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbZIPEfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbZIPEfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZIPEfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:35:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:49678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZIPEfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:35:23 -0400
Date: Wed, 16 Sep 2009 06:35:20 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       yanmin_zhang@linux.intel.com, jens.axboe@oracle.com,
       ink@jurassic.park.msu.ru, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO
 performance
Message-ID: <20090916063520.675f64c6@infradead.org>
In-Reply-To: <20090915162306.66c5ce9d.akpm@linux-foundation.org>
References: <20090915054259.5282e5ba@infradead.org>
	<20090915162306.66c5ce9d.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 16:23:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 15 Sep 2009 05:42:59 +0200
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > Fix the menu idle governor which balances power savings, energy
> > efficiency and performance impact.
> 
> This patch clashes a bit with
> cpuidle-menu-governor-reduce-latency-on-exit.patch (which was sent to
> the ACPI maintainers a month ago and ignored).
> 
> <im-fed-up-with-this-crap-ill-just-merge-it-and-if-it-breaks-dont-blame-me>
> 
> 
> I restaged cpuidle-menu-governor-reduce-latency-on-exit.patch so it
> goes after
> cpuidle-fix-the-menu-governor-to-boost-io-performance.patch. perhaps
> you could take a look at Corrado's change?

ok this patch is an interesting approach, I'll need to check if it's
valid to do this in the cpuidle framework (need to check if "what was
my last residency" stays valid until all the way deep into the next
idle, I kinda fear it won't).

As for the amount of gain.. yeah we're talking about maybe 100 cycles
on a .. say 200 usec latency. But it's a neat optimization if it can
work.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
