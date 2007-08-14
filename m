Return-Path: <linux-kernel-owner+w=401wt.eu-S1761863AbXHNWbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761863AbXHNWbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXHNWbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:31:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51794 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393AbXHNWbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:31:16 -0400
Date: Tue, 14 Aug 2007 15:31:12 -0700 (PDT)
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
In-Reply-To: <20070809131423.GA9927@shell.boston.redhat.com>
Message-ID: <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
References: <20070809131423.GA9927@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Chris Snook wrote:

> This patchset makes the behavior of atomic_read uniform by removing the
> volatile keyword from all atomic_t and atomic64_t definitions that currently
> have it, and instead explicitly casts the variable as volatile in
> atomic_read().  This leaves little room for creative optimization by the
> compiler, and is in keeping with the principles behind "volatile considered
> harmful".

volatile is generally harmful even in atomic_read(). Barriers control
visibility and AFAICT things are fine.
