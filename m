Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbXJEEPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbXJEEPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 00:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXJEEPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 00:15:22 -0400
Received: from gw.goop.org ([64.81.55.164]:60618 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXJEEPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 00:15:21 -0400
Message-ID: <4705BA56.5080605@goop.org>
Date: Thu, 04 Oct 2007 21:15:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Hugh Dickens <hugh@veritas.com>, David Rientjes <rientjes@google.com>,
       Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
References: <470596C4.8060804@goop.org> <20071004215231.42b1bc21@bree.surriel.com>
In-Reply-To: <20071004215231.42b1bc21@bree.surriel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Either of these two would work.  Another alternative could be to
> let test_and_clear_pte_flags have an exception table entry, where
> we jump right to the next instruction if the instruction clearing
> the flag fails.
>
> That is the essentially variant you need for Xen, except the fast
> path is still exactly the same it is as when running on native
> hardware.
>   

Hm, that wouldn't end up clearing the bit.  You'd need a Xen-specific
exception handler to do that, which would turn the whole thing into
Xen-specific code, and you're back at adding a pv-op.

    J

