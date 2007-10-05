Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbXJET5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbXJET5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762273AbXJET4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:56:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761872AbXJET4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:56:51 -0400
Date: Fri, 5 Oct 2007 15:56:34 -0400
From: Rik van Riel <riel@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>, David Rientjes <rientjes@google.com>,
       Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
Message-ID: <20071005155634.7d677970@cuia.boston.redhat.com>
In-Reply-To: <47069315.8030802@goop.org>
References: <470596C4.8060804@goop.org>
	<Pine.LNX.4.64.0710051146300.25518@blonde.wat.veritas.com>
	<20071005145828.17ba9c69@cuia.boston.redhat.com>
	<47069315.8030802@goop.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2007 12:40:05 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Well, isn't the correct fix to make Xen take all the pagetable locks
> while pinning/unpinning?  Adding exception handling to
> test_and_clear_bit would solve this particular race, but are there
> others (either now or potentially)?  Seems fragile.

You're right, holding the pagetable lock(s) across pinning/unpinning
operations would avoid the problem too.

While we do not care about the accessed bit, there are similar operations
going on with the dirty bit - which is a lot more important :)

-- 
All Rights Reversed
