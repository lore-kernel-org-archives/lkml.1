Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbXFAQIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbXFAQIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbXFAQIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:08:25 -0400
Received: from waste.org ([66.93.16.53]:39450 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbXFAQIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:08:24 -0400
Date: Fri, 1 Jun 2007 11:08:02 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070601160802.GL11166@waste.org>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p731wgxds85.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 03:42:50PM +0200, Andi Kleen wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > Reimplementation of the cond calls which uses a hash table to hold the active
> > cond_calls. It permits to first arm a cond_call and then load supplementary
> > modules that contain this cond_call.
> 
> Hash table is probably overkill. This is a very very slow path operation.
> Can you simplify the code? Just a linked list of all the condcall segments
> should be enough  and then walk it.

I think it could be greatly simplified by using symbols instead of
strings.

That is, doing cond_call(foo, func()) rather than cond_call("foo",
func()). Here foo is a structure or type holding the relevant info to
deal with the cond_call infrastructure. For unoptimized architectures,
it can simply be a bool, which will be faster.

This has the added advantage that the compiler will automatically pick
up any misspellings of these things. And it saves the space we'd use
on the hash table too.

-- 
Mathematics is the supreme nostalgia of our time.
