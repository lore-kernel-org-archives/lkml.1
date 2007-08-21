Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbXHUVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbXHUVn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXHUVnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:43:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXHUVnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:43:51 -0400
Message-ID: <46CB5C89.2070807@redhat.com>
Date: Tue, 21 Aug 2007 17:43:37 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
References: <20070820215040.937296148@sgi.com>  <1187692586.6114.211.camel@twins>  <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com> <1187730812.5463.12.camel@lappy> <Pine.LNX.4.64.0708211418120.3267@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708211418120.3267@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

> I want general improvements to reclaim to address the issues that you see 
> and other issues related to reclaim instead of the strange code that makes 
> PF_MEMALLOC allocs compete for allocations from a single slab and putting 
> logic into the kernel to decide which allocs to fail. We can reclaim after 
> all. Its just a matter of finding the right way to do this. 

The simplest way of achieving that would be to allow
recursion of the page reclaim code, under the condition
that the second level call can only reclaim clean pages,
while the "outer" call does what the VM does today.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
