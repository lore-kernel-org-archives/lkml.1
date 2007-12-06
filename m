Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbXLFU1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbXLFU1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXLFU1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:27:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752212AbXLFU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:27:22 -0500
Date: Thu, 6 Dec 2007 12:27:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-Id: <20071206122701.85627fb4.akpm@linux-foundation.org>
In-Reply-To: <200712061204.14854.phillips@phunq.net>
References: <200712051603.02183.phillips@phunq.net>
	<200712060148.53805.phillips@phunq.net>
	<20071206035511.83bef995.akpm@linux-foundation.org>
	<200712061204.14854.phillips@phunq.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 12:04:14 -0800
Daniel Phillips <phillips@phunq.net> wrote:

> Any idea 
> how to extend the accounting idea to all tasks involved in a particular 
> block device stack?

SMOP, I'd have thought.  As long as each piece of code which handles data
for this stack knows that it's handling data for that stack it should be
able to account its memory allocations.

The tricky part will be networking allocations because a NIC can of course
handle data for all sorts of consumers.  But I expect this can be greatly
simplified with a few heuristics - work out how much memory your typical
networking stack will allocate for a frame and tack that onto the total.
Couple of pages worst case..
