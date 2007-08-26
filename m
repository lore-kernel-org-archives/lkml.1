Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXHZExY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXHZExY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 00:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXHZExP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 00:53:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXHZExO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 00:53:14 -0400
Message-ID: <46D10721.7070406@redhat.com>
Date: Sun, 26 Aug 2007 00:52:49 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
References: <20070820215040.937296148@sgi.com>  <1187692586.6114.211.camel@twins>  <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com>  <1187730812.5463.12.camel@lappy>  <Pine.LNX.4.64.0708211418120.3267@schroedinger.engr.sgi.com>  <1187734144.5463.35.camel@lappy>  <Pine.LNX.4.64.0708211532560.5728@schroedinger.engr.sgi.com>  <1187766156.6114.280.camel@twins>  <Pine.LNX.4.64.0708221157180.13813@schroedinger.engr.sgi.com> <1187813025.5463.85.camel@lappy> <Pine.LNX.4.64.0708221306080.15775@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708221306080.15775@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 22 Aug 2007, Peter Zijlstra wrote:
> 
>>> That is an extreme case that AFAIK we currently ignore and could be 
>>> avoided with some effort.
>> Its not extreme, not even rare, and its handled now. Its what
>> PF_MEMALLOC is for.
> 
> No its not. If you have all pages allocated as anonymous pages and your 
> writeout requires more pages than available in the reserves then you are 
> screwed either way regardless if you have PF_MEMALLOC set or not.

Only if the _first_ writeout needs more pages.

If the sum of all writeouts need more pages than you have
available, that is fine.  After all, buffer heads and some
other metadata is freed on IO completion.

Recursive reclaim will also be able to free the data pages
after IO completion, and really fix the problem.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
