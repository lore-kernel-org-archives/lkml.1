Return-Path: <linux-kernel-owner+w=401wt.eu-S935818AbXHNWwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935818AbXHNWwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932209AbXHNWv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:51:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53259 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765147AbXHNWvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:51:24 -0400
Date: Tue, 14 Aug 2007 15:51:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Chris Snook <csnook@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <46C23078.4040109@redhat.com>
Message-ID: <Pine.LNX.4.64.0708141550001.490@schroedinger.engr.sgi.com>
References: <20070809131423.GA9927@shell.boston.redhat.com>
 <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
 <46C23078.4040109@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Chris Snook wrote:

> But barriers force a flush of *everything* in scope, which we generally don't
> want.  On the other hand, we pretty much always want to flush atomic_*
> operations.  One way or another, we should be restricting the volatile
> behavior to the thing that needs it.  On most architectures, this patch set
> just moves that from the declaration, where it is considered harmful, to the
> use, where it is considered an occasional necessary evil.

Then we would need

	atomic_read()

and

	atomic_read_volatile()

atomic_read_volatile() would imply an object sized memory barrier before 
and after?
