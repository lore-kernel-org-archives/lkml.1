Return-Path: <linux-kernel-owner+w=401wt.eu-S1750906AbXA0WTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906AbXA0WTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 17:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXA0WTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 17:19:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbXA0WTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 17:19:41 -0500
Message-ID: <45BBCFE9.5010600@redhat.com>
Date: Sat, 27 Jan 2007 17:19:21 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>	<45B9A00C.4040701@yahoo.com.au>	<Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>	<20070126031300.59f75b06.akpm@osdl.org>	<Pine.LNX.4.64.0701260742340.6141@schroedinger.engr.sgi.com>	<20070126101027.90bf3e63.akpm@osdl.org>	<Pine.LNX.4.64.0701261021200.7848@schroedinger.engr.sgi.com> <20070126104206.f0b45f74.akpm@osdl.org>
In-Reply-To: <20070126104206.f0b45f74.akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Of course it would.  But how do you know it is "too expensive"?  We "scan
> all the vmas mapping a page" as a matter of course in the page scanner -
> millions of times a minute.  If that's "too expensive" then ouch.

We can do it lazily.

At mlock time, move pages onto the mlocked list, unless they
are there already.

On munlock, move pages to the active list.  For mlock-only
memory (shared memory segments?) we could add a simple check
to see if the next process on the list has the page mlocked,
checking only that one.

While scanning the active list, move mlocked pages that are
found back onto the mlocked list.

This lazy movement of pages will impact shared libraries,
but probably not shared memory segments.

Does this sound workable?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
