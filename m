Return-Path: <linux-kernel-owner+w=401wt.eu-S2992853AbXDRREc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992853AbXDRREc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992861AbXDRREc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:04:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992853AbXDRREb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:04:31 -0400
Message-ID: <46264F91.4070106@redhat.com>
Date: Wed, 18 Apr 2007 13:04:17 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: =?UTF-8?B?IuCkheCkreCkv+CknOCkv+CkpCDgpK3gpYvgpKrgpJ/gpJXgpLAgKEFiaGlq?=
	 =?UTF-8?B?aXQgQmhvcGF0a2FyKSI=?= <bainonline@gmail.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, akpm@osdl.org, jgarzik@pobox.com
Subject: Re: [PATCH] [RFC] Throttle swappiness for interactive tasks
References: <2ff216280704180510w28136a6cw6816f834593aff13@mail.gmail.com>
In-Reply-To: <2ff216280704180510w28136a6cw6816f834593aff13@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

अभिजित भोपटकर (Abhijit Bhopatkar) wrote:
> The mm structures of interactive tasks are marked and
> the pages belonging to them are never shifted to inactive
> list in lru algorithm. Thus keeping interactive tasks in
> memory as long as possible.
> The interactivity is already determined by schedular so
> we reuse that knowledge to mark the mm structures.
> 
> Signed-off-by: Abhijit Bhopatkar <bainonline@gmail.com>
> ---

Lying to the VM doesn't seem like the best way to handle this.  A lot of tasks, 
including interactive ones have some/many pages that they touch once during 
startup, and don't touch again for a very long time, if ever.  We want these 
pages swapped out long before the box swaps out the working set of our 
non-interactive processes.

I like the general idea of swap priority influenced by scheduler priority, but 
if we're going to do that, we should do it in a general way that's independent 
of scheduler implementation, so it'll be useful to soft real-time users and 
still relevant if (when?) we replace the current scheduler with something else 
lacking a special "interactive" flag.

	-- Chris
