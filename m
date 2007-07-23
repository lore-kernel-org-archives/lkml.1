Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbXGWQdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbXGWQdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410AbXGWQd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:33:27 -0400
Received: from mx1.suse.de ([195.135.220.2]:43042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbXGWQdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:33:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
Date: Mon, 23 Jul 2007 18:33:20 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <200707231813.26859.ak@suse.de> <Pine.LNX.4.64.0707232152250.22155@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707232152250.22155@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231833.20678.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, but _that_ address (of the bit-string) is protected already -- by the
> implicit memory barrier due to the LOCK prefix.

Compiler barrier != CPU barrier.

The memory clobber is a compiler barrier that prevents its global optimizer
from moving memory references. The CPU memory ordering guarantees are completely 
independent from this.


> We shouldn't really be 
> caring about any other memory addresses, so it doesn't affect the
> correctness of the bitops API at all.

The problem is the relationship to other operations.

This is not theoretic and we have had bugs because of this.

-Andi

 
