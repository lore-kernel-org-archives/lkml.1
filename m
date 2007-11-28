Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbXK1APy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbXK1APy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXK1APp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:15:45 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41725 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648AbXK1APp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:15:45 -0500
Date: Tue, 27 Nov 2007 16:15:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, travis@sgi.com, ak@suse.de,
       pageexec@freemail.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu
 variables
In-Reply-To: <20071127234821.GC31491@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0711271609440.7293@schroedinger.engr.sgi.com>
References: <20071127215052.090968000@sgi.com> <20071127215054.660250000@sgi.com>
 <20071127221628.GG24223@one.firstfloor.org> <20071127151241.038c146d.akpm@linux-foundation.org>
 <20071127152122.1d5fbce3.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711271522050.6713@schroedinger.engr.sgi.com>
 <20071127154213.11970e63.akpm@linux-foundation.org> <20071127234821.GC31491@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Andi Kleen wrote:

> It was demonstrated useful for some specific cases, like context switch early
> fetch on IA64. But I agree the prefetch on each list_for_each() is probably
> a bad idea and should be removed. Will also help code size.

Looks like sum_vm_events() is only ever called from all_vm_events(). 
Callers of all_vm_events():

App monitoring?
arch/s390/appldata/appldata_mem.c:      all_vm_events(ev);

Leds:
drivers/parisc/led.c:   all_vm_events(events);

proc out put for /proc/vmstat:
mm/vmstat.c:    all_vm_events(e);

All of that does not seem to be performance critical 
