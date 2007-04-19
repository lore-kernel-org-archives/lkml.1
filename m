Return-Path: <linux-kernel-owner+w=401wt.eu-S1031147AbXDSEoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031147AbXDSEoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 00:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031154AbXDSEoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 00:44:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031147AbXDSEoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 00:44:20 -0400
Message-ID: <4626F038.8020606@redhat.com>
Date: Thu, 19 Apr 2007 00:29:44 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Abhijit Bhopatkar <bainonline@gmail.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, akpm@osdl.org, jgarzik@pobox.com,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH] [RFC] Throttle swappiness for interactive tasks
References: <2ff216280704180510w28136a6cw6816f834593aff13@mail.gmail.com>	 <46268519.7080702@redhat.com> <2ff216280704182014h6ff2eed3g4301ee8d1bfbed14@mail.gmail.com>
In-Reply-To: <2ff216280704182014h6ff2eed3g4301ee8d1bfbed14@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Abhijit Bhopatkar wrote:

> I just wanted to know weather its worth going forward or we have
> better reasons to discount any such direction?

The reason that the wrong pages get swapped out sometimes
could be due to a side effect of the way the swappiness
policy is implemented.

While the VM only reclaims page cache pages, it will still
rotate through the anonymous pages on the LRU list, which
effectively randomizes the order of those pages on the list.

I need to get back to benchmarking my patch to split the
lists - anonymous and other swap backed pages on one set
of pageout lists, filesystem backed pages on another list.

One report I got was that the system is more interactive
under very heavy load, and my desktop system at the office
seems to behave better than it used to when I get back to
it after a few days.

Unfortunately my main desktop system at home depends on
Xen, so it's not as easy to use that patch there :(

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
