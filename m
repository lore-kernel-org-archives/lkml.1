Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXHNXOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXHNXOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXHNXO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:14:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40718 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753015AbXHNXOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:14:24 -0400
Date: Tue, 14 Aug 2007 16:14:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Chris Snook <csnook@redhat.com>
cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ak@suse.de, heiko.carstens@de.ibm.com, davem@davemloft.net,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <46C2350A.1010807@redhat.com>
Message-ID: <Pine.LNX.4.64.0708141612590.693@schroedinger.engr.sgi.com>
References: <20070809131423.GA9927@shell.boston.redhat.com>
 <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in>
 <46C2350A.1010807@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Chris Snook wrote:

> Because atomic operations are generally used for synchronization, which
> requires volatile behavior.  Most such codepaths currently use an inefficient
> barrier().  Some forget to and we get bugs, because people assume that
> atomic_read() actually reads something, and atomic_write() actually writes
> something.  Worse, these are architecture-specific, even compiler
> version-specific bugs that are often difficult to track down.

Looks like we need to have lock and unlock semantics?

atomic_read()

which has no barrier or volatile implications.

atomic_read_for_lock

	Acquire semantics?


atomic_read_for_unlock

	Release semantics?

