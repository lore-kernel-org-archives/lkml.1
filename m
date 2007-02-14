Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbXBNS5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbXBNS5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932447AbXBNS5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:57:14 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:43322 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932442AbXBNS5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:57:13 -0500
Date: Wed, 14 Feb 2007 10:57:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch] mm: NUMA replicated pagecache
In-Reply-To: <20070213060924.GB20644@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0702141052350.975@schroedinger.engr.sgi.com>
References: <20070213060924.GB20644@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Nick Piggin wrote:

> Just tinkering around with this and got something working, so I'll see
> if anyone else wants to try it.
> 
> Not proposing for inclusion, but I'd be interested in comments or results.

We would be very interested in such a feature. We have another hack that 
shows up to 40% performance improvements.

> At the moment the code is a bit ugly, but it won't take much to make it a
> completely standalone ~400 line module with just a handful of hooks into
> the core mm. So if anyone really wants it, it could be quite realistic to
> get into an includable form.

Would be great but I am a bit skeptical regarding the locking and the 
additonal overhead moving back and forth between replications and non 
replicated page state.

> At some point I did take a look at Dave Hansen's page replication patch for
> ideas, but didn't get far because he was doing a per-inode scheme and I was
> doing per-page. No judgments on which approach is better, but I feel this
> per-page patch is quite neat.

Definitely looks better.

> - Would be nice to transfer master on reclaim. This should be quite easy,
>   must transfer relevant flags, and only if !PagePrivate (which reclaim
>   takes care of).

Transfer master? Meaning you need to remove the replicated pages? Removing 
of replicated pages should transfer reference bit?

> - Should go nicely with lockless pagecache, but haven't merged them yet.

When is that going to happen? Soon I hope?
